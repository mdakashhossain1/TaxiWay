<?php

namespace App\Http\Controllers\Api\Driver;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Driver;
use App\Services\ChatService;
use App\Services\PushNotificationService;
use App\Services\RideAllocationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RideController extends Controller
{
    public function __construct(
        private readonly RideAllocationService $allocation,
        private readonly PushNotificationService $notifications,
        private readonly ChatService $chat,
    ) {}

    private function driver(Request $request): Driver
    {
        abort_unless($request->user() instanceof Driver, 403);

        return $request->user();
    }

    public function index(Request $request): JsonResponse
    {
        $driver = $this->driver($request);
        $filter = $request->query('status', 'upcoming');

        $query = $driver->bookings()->with(['customer', 'category']);

        $query = $filter === 'completed'
            ? $query->where('status', 'completed')
            : $query->whereIn('status', Booking::CONFIRMED_STATUSES);

        return response()->json(['data' => $query->latest()->get()]);
    }

    public function show(Request $request, Booking $booking): JsonResponse
    {
        $driver = $this->driver($request);
        abort_unless($booking->driver_id === $driver->id, 404);

        return response()->json(['data' => $booking->load(['customer', 'category'])]);
    }

    /**
     * Confirms a pending offer. Only valid while the booking is still
     * "driver_offered" for this driver — an expired/already-decided offer
     * (e.g. lost the race to `ExpireRideOffer`) is rejected with 422 rather
     * than silently succeeding.
     */
    public function accept(Request $request, Booking $booking): JsonResponse
    {
        $driver = $this->driver($request);
        abort_unless($booking->driver_id === $driver->id, 404);
        abort_if($booking->status !== 'driver_offered', 422, 'This ride offer is no longer available.');

        $booking->update(['status' => 'driver_assigned', 'offer_expires_at' => null]);

        $this->chat->ensureRideConversation($booking);

        $this->notifications->send(
            $booking->customer,
            'driver_accepted',
            'Driver accepted your ride',
            "{$driver->name} is on the way to {$booking->pickup_address}.",
            ['booking_id' => $booking->id],
        );

        $this->notifications->send(
            $driver,
            'ride_assigned',
            'Ride confirmed',
            "You're confirmed for the ride to {$booking->destination_address}.",
            ['booking_id' => $booking->id],
        );

        return response()->json(['data' => $booking->fresh(['customer', 'category'])]);
    }

    /** Declines a pending offer; the booking goes back out to the next eligible driver. */
    public function reject(Request $request, Booking $booking): JsonResponse
    {
        $driver = $this->driver($request);
        abort_unless($booking->driver_id === $driver->id, 404);
        abort_if($booking->status !== 'driver_offered', 422, 'This ride offer is no longer available.');

        $booking->update([
            'rejected_driver_ids' => [...($booking->rejected_driver_ids ?? []), $driver->id],
            'driver_id' => null,
            'vehicle_id' => null,
        ]);

        $this->allocation->offerNextDriver($booking->fresh());

        return response()->json(['message' => 'Ride declined.']);
    }

    /**
     * Marks a ride done and, per the PRD's subscription rule ("each
     * qualifying completed ride decrements quota"), consumes one ride from
     * the driver's active subscription in the same transaction.
     */
    public function markCompleted(Request $request, Booking $booking): JsonResponse
    {
        $driver = $this->driver($request);
        abort_unless($booking->driver_id === $driver->id, 404);
        abort_if($booking->status === 'completed', 422, 'Ride is already marked completed.');

        DB::transaction(function () use ($booking, $driver) {
            $booking->update(['status' => 'completed', 'payment_status' => 'paid']);

            $driver->increment('total_trips');

            $subscription = $driver->subscription()->with('plan')->first();
            if ($subscription) {
                $subscription->increment('rides_used');

                if ($subscription->rides_used >= $subscription->plan->rides_included) {
                    $subscription->update(['status' => 'quota_exhausted']);
                }
            }
        });

        $this->notifications->send(
            $booking->customer,
            'ride_completed',
            'Ride completed',
            'Your ride is complete. Thanks for riding with us!',
            ['booking_id' => $booking->id],
        );

        return response()->json(['data' => $booking->fresh(['customer', 'category'])]);
    }
}
