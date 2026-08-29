<?php

namespace App\Services;

use Firebase\JWT\JWK;
use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;

class InvalidFirebaseTokenException extends \RuntimeException {}

/**
 * Verifies Firebase Auth ID tokens without pulling in the full Admin SDK:
 * Firebase ID tokens are standard RS256 JWTs signed with keys published at
 * Google's JWKS endpoint, so checking the signature + standard claims
 * locally is sufficient and avoids a service-account credential entirely.
 *
 * https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
 */
class FirebaseTokenVerifier
{
    private const JWKS_URL = 'https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com';

    private const JWKS_CACHE_KEY = 'firebase:jwks';

    private const JWKS_CACHE_TTL = 3600;

    /**
     * @return array{uid: string, email: ?string, name: ?string, picture: ?string}
     */
    public function verify(string $idToken): array
    {
        $projectId = config('services.firebase.project_id');

        if (! $projectId) {
            throw new InvalidFirebaseTokenException('FIREBASE_PROJECT_ID is not configured.');
        }

        try {
            $keySet = JWK::parseKeySet($this->jwks());
            $claims = (array) JWT::decode($idToken, $keySet);
        } catch (\Throwable $e) {
            throw new InvalidFirebaseTokenException('Invalid Firebase ID token: '.$e->getMessage(), previous: $e);
        }

        if (($claims['aud'] ?? null) !== $projectId) {
            throw new InvalidFirebaseTokenException('Token audience does not match this Firebase project.');
        }

        if (($claims['iss'] ?? null) !== "https://securetoken.google.com/{$projectId}") {
            throw new InvalidFirebaseTokenException('Token issuer does not match this Firebase project.');
        }

        if (empty($claims['sub'])) {
            throw new InvalidFirebaseTokenException('Token is missing a subject claim.');
        }

        return [
            'uid' => $claims['sub'],
            'email' => $claims['email'] ?? null,
            'name' => $claims['name'] ?? null,
            'picture' => $claims['picture'] ?? null,
        ];
    }

    private function jwks(): array
    {
        return Cache::remember(self::JWKS_CACHE_KEY, self::JWKS_CACHE_TTL, function () {
            $response = Http::throw()->get(self::JWKS_URL);

            return $response->json();
        });
    }
}
