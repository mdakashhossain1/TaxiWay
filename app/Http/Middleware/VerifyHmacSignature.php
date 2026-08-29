<?php

namespace App\Http\Middleware;

use App\Models\ApiClient;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Symfony\Component\HttpFoundation\Response;

/**
 * Verifies that every mobile API request was genuinely produced by a known
 * app build and has not been tampered with or replayed.
 *
 * Required headers:
 *   X-Client-Id   the app's public client key (e.g. "taxiway", "taxiwaydriver")
 *   X-Timestamp   unix timestamp the request was signed at
 *   X-Nonce       a random per-request string, unique for this client+timestamp
 *   X-Signature   hex-encoded HMAC-SHA256 of "{METHOD}|{PATH}|{TIMESTAMP}|{NONCE}|{RAW_BODY}"
 *                 keyed with the client's secret
 *
 * All failures return the same generic 401 so a caller cannot use the
 * response to work out *which* check failed (no oracle for forging a
 * signature).
 */
class VerifyHmacSignature
{
    private const MAX_SKEW_SECONDS = 300;

    /** Client secrets essentially never change — caching avoids a DB round-trip on every single mobile API request. Bounded to the same window as clock-skew tolerance so a rotated/deactivated client stops working within a predictable, short time. */
    private const CLIENT_CACHE_TTL = 300;

    public function handle(Request $request, Closure $next): Response
    {
        $clientId = $request->header('X-Client-Id');
        $timestamp = $request->header('X-Timestamp');
        $nonce = $request->header('X-Nonce');
        $signature = $request->header('X-Signature');

        if (! $clientId || ! $timestamp || ! $nonce || ! $signature) {
            return $this->reject();
        }

        if (! ctype_digit((string) $timestamp) || abs(time() - (int) $timestamp) > self::MAX_SKEW_SECONDS) {
            return $this->reject();
        }

        $client = Cache::remember(
            "api_client:{$clientId}",
            self::CLIENT_CACHE_TTL,
            fn () => ApiClient::where('client_key', $clientId)->where('is_active', true)->first(),
        );
        if (! $client) {
            return $this->reject();
        }

        $nonceKey = "hmac_nonce:{$client->client_key}:{$nonce}";
        if (Cache::has($nonceKey)) {
            return $this->reject();
        }

        $payload = implode('|', [
            $request->method(),
            $request->path(),
            $timestamp,
            $nonce,
            $request->getContent(),
        ]);

        $expected = hash_hmac('sha256', $payload, $client->client_secret);

        if (! hash_equals($expected, (string) $signature)) {
            return $this->reject();
        }

        // Only reserve the nonce once the signature has actually verified,
        // so a garbage request can't burn a legitimate future nonce.
        Cache::put($nonceKey, true, self::MAX_SKEW_SECONDS);

        $request->attributes->set('api_client', $client);

        return $next($request);
    }

    private function reject(): Response
    {
        return response()->json(['message' => 'Unauthorized.'], 401);
    }
}
