<?php

namespace App\Http\Controllers\Api\Customer;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DriverController extends Controller
{
    /**
     * Driver + vehicle (with media) info for a given booking, for the
     * customer app's Driver & Vehicle Profile / Full Driver Profile screens.
     */
    public function show(Request $request, Booking $booking): JsonResponse
    {
        abort_unless($request->user() instanceof Customer, 403);
        abort_unless($booking->customer_id === $request->user()->id, 404);
        abort_if($booking->driver === null, 404, 'No driver allocated to this booking yet.');

        $driver = $booking->driver->load(['vehicles.media', 'reviews' => fn ($q) => $q->latest()->limit(20)]);

        return response()->json(['data' => $driver]);
    }
}
