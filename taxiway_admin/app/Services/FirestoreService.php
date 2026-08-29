<?php

namespace App\Services;

use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Http;

/**
 * Minimal Firestore REST client authenticated as the service account
 * (IAM/OAuth2, not a Firebase Auth user) — this is how the Admin SDK talks
 * to Firestore too, so writes made here bypass Security Rules entirely.
 * Deliberately avoids the official google/cloud-firestore package: it pulls
 * in google/gax + the grpc PHP extension, which isn't available on the
 * shared hosting this app targets (see SettingsController's migration
 * workaround for the same constraint). REST + a hand-signed JWT needs
 * nothing beyond firebase/php-jwt, already a dependency for ID-token
 * verification.
 */
class FirestoreService
{
    private const TOKEN_URI = 'https://oauth2.googleapis.com/token';

    private const SCOPE = 'https://www.googleapis.com/auth/datastore';

    /** Upserts a document's fields (leaves any other existing fields alone). */
    public function setDocument(string $relativePath, array $fields): void
    {
        $projectId = config('services.firebase.project_id');
        $mask = implode('&', array_map(
            fn (string $field) => 'updateMask.fieldPaths='.urlencode($field),
            array_keys($fields)
        ));

        $url = "https://firestore.googleapis.com/v1/projects/{$projectId}/databases/(default)/documents/{$relativePath}?{$mask}";

        Http::withToken($this->accessToken())
            ->patch($url, ['fields' => $this->encodeFields($fields)])
            ->throw();
    }

    private function accessToken(): string
    {
        return Cache::remember('firestore:access_token', 3300, function () {
            $credentials = $this->credentials();
            $now = time();

            $jwt = JWT::encode([
                'iss' => $credentials['client_email'],
                'scope' => self::SCOPE,
                'aud' => self::TOKEN_URI,
                'iat' => $now,
                'exp' => $now + 3600,
            ], $credentials['private_key'], 'RS256');

            $response = Http::asForm()->post(self::TOKEN_URI, [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt,
            ])->throw();

            return $response->json('access_token');
        });
    }

    private function credentials(): array
    {
        $path = env('FIREBASE_CREDENTIALS');

        abort_unless($path && File::exists($path), 500, 'Firebase credentials are not configured.');

        return json_decode(File::get($path), true);
    }

    private function encodeFields(array $fields): array
    {
        return array_map($this->encodeValue(...), $fields);
    }

    private function encodeValue(mixed $value): array
    {
        return match (true) {
            is_string($value) => ['stringValue' => $value],
            is_bool($value) => ['booleanValue' => $value],
            is_int($value) => ['integerValue' => (string) $value],
            is_array($value) => ['arrayValue' => ['values' => array_map($this->encodeValue(...), $value)]],
            default => ['nullValue' => null],
        };
    }
}
