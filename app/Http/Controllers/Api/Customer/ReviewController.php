<?php

namespace App\Http\Controllers\Api\Customer;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Customer;
use App\Models\Driver;
use App\Models\Review;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        abort_unless($request->user() instanceof Customer, 403);
        $customer = $request->user();

        $data = $request->validate([
            'booking_id' => ['required', 'exists:bookings,id'],
            'rating' => ['required', 'integer', 'min:1', 'max:5'],
            'comment' => ['nullable', 'string', 'max:1000'],
            'tags' => ['nullable', 'array'],
            'tags.*' => ['string'],
        ]);

        $booking = Booking::findOrFail($data['booking_id']);
        abort_unless($booking->customer_id === $customer->id, 404);
        abort_if($booking->status !== 'completed', 422, 'Only completed rides can be reviewed.');
        abort_if($booking->review()->exists(), 422, 'This ride has already been reviewed.');

        $review = Review::create([
            ...$data,
            'customer_id' => $customer->id,
            'driver_id' => $booking->driver_id,
        ]);

        $this->recalculateDriverRating($booking->driver_id);

        return response()->json(['data' => $review], 201);
    }

    private function recalculateDriverRating(?int $driverId): void
    {
        if (! $driverId) {
            return;
        }

        $average = Review::where('driver_id', $driverId)->avg('rating');

        if ($average !== null) {
            Driver::whereKey($driverId)->update(['rating' => round($average, 2)]);
        }
    }
}
