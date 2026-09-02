<?php

namespace App\Http\Controllers\Api\Driver;

use App\Http\Controllers\Controller;
use App\Models\Driver;
use App\Services\FirebaseTokenVerifier;
use App\Services\InvalidFirebaseTokenException;
use App\Services\OtpCooldownException;
use App\Services\OtpService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function __construct(
        private readonly OtpService $otp,
        private readonly FirebaseTokenVerifier $firebase,
    ) {}

    /**
     * Any phone number can request a driver OTP — self-registration is
     * allowed. The driver record itself (verification_status: pending) is
     * only created on successful verifyOtp; ops then verifies KYC offline
     * via the admin panel before the driver can take rides.
     */
    public function sendOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
        ]);

        return $this->respondWithOtp('driver', $data['phone']);
    }

    public function verifyOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
            'code' => ['required', 'digits:6'],
        ]);

        $result = $this->otp->verify('driver', $data['phone'], $data['code']);
        if ($response = $this->invalidOtpResponse($result)) {
            return $response;
        }

        $driver = Driver::firstOrCreate(
            ['phone' => $data['phone']],
            ['name' => 'New Driver']
        );
        $token = $driver->createToken('device')->plainTextToken;

        return response()->json([
            'data' => [
                'driver' => $driver,
                'token' => $token,
            ],
        ]);
    }

    /**
     * Google Sign-In (Firebase Auth) login. Same identity-merge and
     * phone-linking rules as the customer flow — see that controller's
     * `google()` for the reasoning. A driver created via Google still
     * starts at verification_status "pending" like any self-registered
     * driver; KYC review is unaffected by the login method.
     */
    public function google(Request $request): JsonResponse
    {
        $data = $request->validate([
            'id_token' => ['required', 'string'],
        ]);

        try {
            $profile = $this->firebase->verify($data['id_token']);
        } catch (InvalidFirebaseTokenException) {
            return response()->json(['message' => 'Invalid Google sign-in token.'], 422);
        }

        $driver = Driver::where('google_id', $profile['uid'])->first();

        if (! $driver && $profile['email']) {
            $driver = Driver::where('email', $profile['email'])->first();
        }

        if ($driver) {
            $driver->fill(array_filter([
                'google_id' => $profile['uid'],
                'photo_url' => $driver->photo_url ?: $profile['picture'],
            ]))->save();
        } else {
            $driver = Driver::create([
                'name' => $profile['name'] ?? 'New Driver',
                'email' => $profile['email'],
                'google_id' => $profile['uid'],
                'photo_url' => $profile['picture'],
            ]);
        }

        $token = $driver->createToken('device')->plainTextToken;

        return response()->json([
            'data' => [
                'driver' => $driver,
                'token' => $token,
                'phone_linked' => $driver->phone !== null,
            ],
        ]);
    }

    /** Sends an OTP to attach a phone number to the authenticated driver's account. */
    public function sendPhoneLinkOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
        ]);

        return $this->respondWithOtp('driver', $data['phone']);
    }

    /** Verifies the OTP and attaches the phone number to the authenticated driver. */
    public function verifyPhoneLink(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
            'code' => ['required', 'digits:6'],
        ]);

        $result = $this->otp->verify('driver', $data['phone'], $data['code']);
        if ($response = $this->invalidOtpResponse($result)) {
            return $response;
        }

        $driver = $request->user();

        $takenByAnotherAccount = Driver::where('phone', $data['phone'])
            ->where('id', '!=', $driver->id)
            ->exists();

        if ($takenByAnotherAccount) {
            return response()->json(['message' => 'This phone number is already linked to another account.'], 422);
        }

        $driver->update(['phone' => $data['phone']]);

        return response()->json(['data' => ['driver' => $driver]]);
    }

    /** Registers/refreshes the FCM token for the authenticated driver's current device. */
    public function updateDeviceToken(Request $request): JsonResponse
    {
        $data = $request->validate([
            'fcm_token' => ['required', 'string'],
        ]);

        $request->user()->update(['fcm_token' => $data['fcm_token']]);

        return response()->json(['message' => 'Device token registered.']);
    }

    /** @param array{success: bool, expired: bool} $result */
    private function invalidOtpResponse(array $result): ?JsonResponse
    {
        if ($result['success']) {
            return null;
        }

        return response()->json([
            'message' => $result['expired'] ? 'OTP expired. Please request a new one.' : 'Invalid OTP. Please try again.',
            'expired' => $result['expired'],
        ], 422);
    }

    private function respondWithOtp(string $scope, string $phone): JsonResponse
    {
        try {
            $otp = $this->otp->generateAndSend($scope, $phone);
        } catch (OtpCooldownException $e) {
            return response()->json([
                'message' => "Please wait {$e->retryAfterSeconds}s before requesting another OTP.",
                'retry_after' => $e->retryAfterSeconds,
            ], 429);
        }

        return response()->json([
            'message' => 'OTP sent.',
            ...($otp['debug'] ? ['debug_otp' => $otp['code']] : []),
        ]);
    }
}
