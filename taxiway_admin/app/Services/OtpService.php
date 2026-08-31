<?php

namespace App\Services;

use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Generates and verifies short-lived OTP codes. Whether a code is actually
 * sent via an SMS gateway or just logged (debug mode) is controlled by
 * config('services.sms.enabled'), set from Settings > SMS Gateway — never
 * inferred from whether the gateway call itself succeeds, so a live-mode
 * gateway outage can't accidentally start leaking OTPs into API responses.
 *
 * Returning the code in the API response (as opposed to just logging it) is
 * additionally gated to local/testing environments: SMS being disabled is
 * the out-of-the-box default on a fresh deploy, and without this gate any
 * caller — authenticated only by the app's shared HMAC secret, not by
 * owning the phone number — could request an OTP for an arbitrary number
 * and read the real code straight out of the response, a full account
 * takeover. In production, a caller with SMS disabled simply can't
 * complete OTP login until an admin configures the gateway.
 */
class OtpService
{
    private const TTL_SECONDS = 300;

    /** Returns ['code' => ..., 'debug' => bool] — callers should only expose 'code' in the response when 'debug' is true. */
    public function generateAndSend(string $scope, string $phone): array
    {
        $code = (string) random_int(100000, 999999);

        Cache::put($this->key($scope, $phone), $code, self::TTL_SECONDS);

        $enabled = (bool) config('services.sms.enabled');

        if ($enabled) {
            try {
                $this->callGateway($phone, $code)->throw();
            } catch (\Throwable $e) {
                // The code is already cached and verifiable even if delivery failed —
                // surface the failure in logs rather than breaking the OTP flow.
                Log::warning("SMS gateway failed for {$scope}:{$phone}: {$e->getMessage()}");
            }
        } else {
            Log::info("OTP for {$scope}:{$phone} is {$code} (valid for 5 minutes) — SMS gateway disabled, debug mode.");
        }

        $debugExposureAllowed = ! $enabled && app()->environment(['local', 'testing']);

        return ['code' => $code, 'debug' => $debugExposureAllowed];
    }

    public function verify(string $scope, string $phone, string $code): bool
    {
        $expected = Cache::get($this->key($scope, $phone));

        if ($expected === null || ! hash_equals($expected, $code)) {
            return false;
        }

        Cache::forget($this->key($scope, $phone));

        return true;
    }

    /**
     * Sends a real message through the currently-saved gateway config,
     * regardless of the live/debug toggle — used by Settings > SMS Gateway's
     * "Send Test SMS" action so an admin can verify credentials/payload shape
     * before flipping Live Mode on for real users.
     *
     * @param string|null $mode 'otp' or 'dlt' to test that profile specifically,
     *                          or null to use the currently active mode.
     */
    public function sendTest(string $phone, ?string $mode = null): array
    {
        $code = (string) random_int(100000, 999999);
        $mode = $this->resolveMode($mode);

        try {
            $response = $this->callGateway($phone, $code, $mode);

            return [
                'success' => $response->successful(),
                'status' => $response->status(),
                'body' => $response->body(),
                'code' => $code,
                'mode' => $mode,
            ];
        } catch (\Throwable $e) {
            return ['success' => false, 'status' => null, 'body' => $e->getMessage(), 'code' => $code, 'mode' => $mode];
        }
    }

    private function callGateway(string $phone, string $code, ?string $mode = null): \Illuminate\Http\Client\Response
    {
        $mode = $this->resolveMode($mode);
        $profile = (array) config("services.sms.{$mode}");

        $payload = json_decode(strtr($profile['payload_template'] ?? '', [
            '{otp}' => $code,
            '{phone}' => $phone,
            '{template_id}' => (string) ($profile['template_id'] ?? ''),
            '{sender_id}' => (string) ($profile['sender_id'] ?? ''),
            '{entity_id}' => (string) ($profile['entity_id'] ?? ''),
        ]), true, flags: JSON_THROW_ON_ERROR);

        $request = Http::withHeaders([
            'Authorization' => config('services.sms.api_key'),
            'accept' => 'application/json',
        ]);

        $url = $profile['payload_url'] ?? '';

        return strtolower($profile['method'] ?? 'post') === 'get'
            ? $request->get($url, $payload)
            : $request->post($url, $payload);
    }

    private function resolveMode(?string $mode): string
    {
        $mode = $mode ?? config('services.sms.mode', 'otp');

        return in_array($mode, ['otp', 'dlt'], true) ? $mode : 'otp';
    }

    private function key(string $scope, string $phone): string
    {
        return "otp:{$scope}:{$phone}";
    }
}
