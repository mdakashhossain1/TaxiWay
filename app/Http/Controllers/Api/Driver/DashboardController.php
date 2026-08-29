<?php

namespace App\Http\Controllers\Api\Driver;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Driver;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        abort_unless($request->user() instanceof Driver, 403);
        $driver = $request->user();

        $nextRide = $driver->bookings()
            ->with(['customer', 'category'])
            ->whereIn('status', Booking::CONFIRMED_STATUSES)
            ->oldest()
            ->first();

        $pendingOffer = $driver->bookings()
            ->with(['customer', 'category'])
            ->where('status', 'driver_offered')
            ->first();

        $subscription = $driver->subscription()->with('plan')->first();

        return response()->json([
            'data' => [
                'driver' => $driver,
                'next_ride' => $nextRide,
                'pending_offer' => $pendingOffer,
                'subscription' => $subscription,
            ],
        ]);
    }
}
