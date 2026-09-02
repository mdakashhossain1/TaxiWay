<?php

namespace App\Http\Controllers\Api\Customer;

use App\Http\Controllers\Controller;
use App\Models\Customer;
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

    public function sendOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
        ]);

        return $this->respondWithOtp('customer', $data['phone']);
    }

    public function verifyOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
            'code' => ['required', 'digits:6'],
        ]);

        $result = $this->otp->verify('customer', $data['phone'], $data['code']);
        if ($response = $this->invalidOtpResponse($result)) {
            return $response;
        }

        $isNewCustomer = ! Customer::where('phone', $data['phone'])->exists();

        $customer = Customer::firstOrCreate(
            ['phone' => $data['phone']],
            ['name' => 'New Customer']
        );

        $token = $customer->createToken('device')->plainTextToken;

        return response()->json([
            'data' => [
                'customer' => $customer,
                'is_new_customer' => $isNewCustomer,
                'token' => $token,
            ],
        ]);
    }

    /**
     * Google Sign-In (Firebase Auth) login. Looks the customer up by the
     * Firebase uid, falling back to a phone-flow account with a matching
     * email so the two identities merge instead of duplicating. Phone stays
     * the account's canonical identity — a fresh Google account is created
     * with no phone yet, and `phone_linked` tells the app whether it still
     * needs to route the user through the OTP screen once to attach one.
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

        $customer = Customer::where('google_id', $profile['uid'])->first();

        if (! $customer && $profile['email']) {
            $customer = Customer::where('email', $profile['email'])->first();
        }

        if ($customer) {
            $customer->fill(array_filter([
                'google_id' => $profile['uid'],
                'photo_url' => $customer->photo_url ?: $profile['picture'],
            ]))->save();
        } else {
            $customer = Customer::create([
                'name' => $profile['name'] ?? 'New Customer',
                'email' => $profile['email'],
                'google_id' => $profile['uid'],
                'photo_url' => $profile['picture'],
            ]);
        }

        $token = $customer->createToken('device')->plainTextToken;

        return response()->json([
            'data' => [
                'customer' => $customer,
                'token' => $token,
                'phone_linked' => $customer->phone !== null,
            ],
        ]);
    }

    /** Sends an OTP to attach a phone number to the authenticated customer's account. */
    public function sendPhoneLinkOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
        ]);

        return $this->respondWithOtp('customer', $data['phone']);
    }

    /** Verifies the OTP and attaches the phone number to the authenticated customer. */
    public function verifyPhoneLink(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
            'code' => ['required', 'digits:6'],
        ]);

        $result = $this->otp->verify('customer', $data['phone'], $data['code']);
        if ($response = $this->invalidOtpResponse($result)) {
            return $response;
        }

        $customer = $request->user();

        $takenByAnotherAccount = Customer::where('phone', $data['phone'])
            ->where('id', '!=', $customer->id)
            ->exists();

        if ($takenByAnotherAccount) {
            return response()->json(['message' => 'This phone number is already linked to another account.'], 422);
        }

        $customer->update(['phone' => $data['phone']]);

        return response()->json(['data' => ['customer' => $customer]]);
    }

    /** Registers/refreshes the FCM token for the authenticated customer's current device. */
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
