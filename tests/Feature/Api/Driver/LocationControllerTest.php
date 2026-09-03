<?php

use App\Models\ApiClient;
use App\Models\Driver;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

function signedDriverHeaders(string $method, string $path, string $body, string $token): array
{
    $client = ApiClient::create([
        'name' => 'Taxiway Driver',
        'client_key' => 'taxiwaydriver',
        'client_secret' => 'test-secret',
        'is_active' => true,
    ]);

    $timestamp = (string) time();
    $nonce = bin2hex(random_bytes(8));
    $payload = implode('|', [$method, $path, $timestamp, $nonce, $body]);
    $signature = hash_hmac('sha256', $payload, $client->client_secret);

    return [
        'X-Client-Id' => 'taxiwaydriver',
        'X-Timestamp' => $timestamp,
        'X-Nonce' => $nonce,
        'X-Signature' => $signature,
        'Authorization' => "Bearer {$token}",
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
    ];
}

test('driver location update stores real coordinates end-to-end', function () {
    $driver = Driver::create([
        'name' => 'Test Driver',
        'phone' => '9999999999',
        'verification_status' => 'verified',
    ]);
    $token = $driver->createToken('test')->plainTextToken;

    $body = json_encode(['latitude' => 25.6127, 'longitude' => 85.1618]);
    $headers = signedDriverHeaders('POST', 'api/driver/location', $body, $token);

    $response = $this->call('POST', '/api/driver/location', [], [], [], $this->transformHeadersToServerVars($headers), $body);

    $response->assertOk();
    $response->assertJson(['message' => 'Location updated.']);

    $driver->refresh();
    expect((float) $driver->current_latitude)->toBe(25.6127)
        ->and((float) $driver->current_longitude)->toBe(85.1618)
        ->and($driver->location_updated_at)->not->toBeNull();
});

test('driver location update rejects an unsigned request', function () {
    $driver = Driver::create([
        'name' => 'Test Driver',
        'phone' => '8888888888',
        'verification_status' => 'verified',
    ]);
    $token = $driver->createToken('test')->plainTextToken;

    $response = $this->postJson('/api/driver/location', ['latitude' => 25.6, 'longitude' => 85.1], [
        'Authorization' => "Bearer {$token}",
    ]);

    $response->assertStatus(401);
});

test('driver location update rejects out-of-range coordinates', function () {
    $driver = Driver::create([
        'name' => 'Test Driver',
        'phone' => '7777777777',
        'verification_status' => 'verified',
    ]);
    $token = $driver->createToken('test')->plainTextToken;

    $body = json_encode(['latitude' => 999, 'longitude' => 85.1618]);
    $headers = signedDriverHeaders('POST', 'api/driver/location', $body, $token);

    $response = $this->call('POST', '/api/driver/location', [], [], [], $this->transformHeadersToServerVars($headers), $body);

    $response->assertStatus(422);
});
