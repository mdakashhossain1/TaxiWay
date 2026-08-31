<?php

use App\Http\Controllers\Api\AppConfigController;
use App\Http\Controllers\Api\ChatController;
use App\Http\Controllers\Api\Customer\AuthController as CustomerAuthController;
use App\Http\Controllers\Api\Customer\BookingController;
use App\Http\Controllers\Api\Customer\BulkBookingController;
use App\Http\Controllers\Api\Customer\DriverController;
use App\Http\Controllers\Api\Customer\ProfileController;
use App\Http\Controllers\Api\Customer\ReviewController;
use App\Http\Controllers\Api\Driver\AuthController as DriverAuthController;
use App\Http\Controllers\Api\Driver\DashboardController;
use App\Http\Controllers\Api\Driver\RideController;
use App\Http\Controllers\Api\Driver\ScheduledRideController;
use App\Http\Controllers\Api\Driver\SubscriptionController;
use App\Http\Controllers\Api\VehicleCategoryController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Every route in this file requires a valid HMAC-SHA256 request signature
| (see App\Http\Middleware\VerifyHmacSignature) proving the call came from
| a genuine taxiway or taxiwaydriver build. Routes that also need to know
| *which* logged-in customer/driver is calling additionally require a
| Sanctum bearer token, issued by the two verify-otp endpoints below.
|
*/

Route::middleware('hmac')->group(function () {

    Route::get('/vehicle-categories', [VehicleCategoryController::class, 'index']);
    Route::get('/app-config', [AppConfigController::class, 'index']);

    Route::prefix('customer')->group(function () {
        Route::post('/auth/send-otp', [CustomerAuthController::class, 'sendOtp']);
        Route::post('/auth/verify-otp', [CustomerAuthController::class, 'verifyOtp']);
        Route::post('/auth/google', [CustomerAuthController::class, 'google']);

        Route::middleware('auth:sanctum')->group(function () {
            Route::post('/auth/phone/send-otp', [CustomerAuthController::class, 'sendPhoneLinkOtp']);
            Route::post('/auth/phone/verify', [CustomerAuthController::class, 'verifyPhoneLink']);
            Route::post('/device-token', [CustomerAuthController::class, 'updateDeviceToken']);

            Route::patch('/profile', [ProfileController::class, 'update']);

            Route::post('/chat-token', [ChatController::class, 'customerToken']);

            Route::get('/bookings', [BookingController::class, 'index']);
            Route::post('/bookings', [BookingController::class, 'store']);
            Route::get('/bookings/{booking}', [BookingController::class, 'show']);
            Route::post('/bookings/{booking}/cancel', [BookingController::class, 'cancel']);
            Route::get('/bookings/{booking}/driver', [DriverController::class, 'show']);

            Route::post('/reviews', [ReviewController::class, 'store']);

            Route::post('/bulk-bookings', [BulkBookingController::class, 'store']);
            Route::get('/bulk-bookings/{bulkBooking}', [BulkBookingController::class, 'show']);
            Route::post('/bulk-bookings/{bulkBooking}/confirm', [BulkBookingController::class, 'confirm']);
        });
    });

    Route::prefix('driver')->group(function () {
        Route::post('/auth/send-otp', [DriverAuthController::class, 'sendOtp']);
        Route::post('/auth/verify-otp', [DriverAuthController::class, 'verifyOtp']);
        Route::post('/auth/google', [DriverAuthController::class, 'google']);

        Route::middleware(['auth:sanctum', 'driver.locale'])->group(function () {
            Route::post('/auth/phone/send-otp', [DriverAuthController::class, 'sendPhoneLinkOtp']);
            Route::post('/auth/phone/verify', [DriverAuthController::class, 'verifyPhoneLink']);
            Route::post('/device-token', [DriverAuthController::class, 'updateDeviceToken']);

            Route::post('/chat-token', [ChatController::class, 'driverToken']);

            Route::get('/dashboard', [DashboardController::class, 'index']);

            Route::get('/rides', [RideController::class, 'index']);
            Route::get('/rides/{booking}', [RideController::class, 'show']);
            Route::post('/rides/{booking}/accept', [RideController::class, 'accept']);
            Route::post('/rides/{booking}/reject', [RideController::class, 'reject']);
            Route::post('/rides/{booking}/mark-completed', [RideController::class, 'markCompleted']);

            Route::get('/scheduled-rides', [ScheduledRideController::class, 'index']);
            Route::post('/scheduled-rides/{booking}/accept', [ScheduledRideController::class, 'accept']);
            Route::post('/scheduled-rides/{booking}/decline', [ScheduledRideController::class, 'decline']);

            Route::get('/subscription', [SubscriptionController::class, 'show']);
            Route::post('/subscription/renew', [SubscriptionController::class, 'renew']);
        });
    });
});
