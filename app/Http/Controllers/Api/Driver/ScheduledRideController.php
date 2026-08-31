<?php

namespace App\Http\Controllers\Api\Driver;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Driver;
use App\Services\ChatService;
use App\Services\PushNotificationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Scheduled rides are open to any eligible driver — first to accept wins —
 * unlike RideController's single-driver sequential offer. `accept()` is the
 * one place correctness actually matters: two drivers tapping "Accept"
 * within milliseconds of each other must never both win the same ride.
 */
class ScheduledRideController extends Controller
{
    public function __construct(
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
        $categoryIds = $driver->vehicles()->pluck('vehicle_category_id');

        $bookings = Booking::where('status', 'scheduled_open')
            ->whereIn('vehicle_category_id', $categoryIds)
            // rejected_driver_ids is NULL until the first decline — SQL's NULL
            // propagation makes JSON_CONTAINS(NULL, ...) neither true nor
            // false, so whereJsonDoesntContain alone could wrongly exclude a
            // booking nobody has declined yet. Explicitly allow the NULL case.
            ->where(fn ($q) => $q->whereNull('rejected_driver_ids')->orWhereJsonDoesntContain('rejected_driver_ids', $driver->id))
            ->with(['customer', 'category'])
            ->orderBy('scheduled_at')
            ->get();

        return response()->json(['data' => $bookings]);
    }

    /**
     * Atomic conditional update, not read-then-write: the WHERE clause only
     * matches if the booking is *still* open, so a single UPDATE statement
     * is the actual race-safety mechanism — MySQL serializes concurrent
     * updates to the same row, so only the first to commit affects a row.
     * Everyone else gets $claimed === 0 and a clean 422, never a double
     * assignment.
     */
    public function accept(Request $request, Booking $booking): JsonResponse
    {
        $driver = $this->driver($request);
        abort_if($booking->type !== 'scheduled', 404);

        $vehicle = $driver->vehicles()->where('vehicle_category_id', $booking->vehicle_category_id)->first();
        abort_unless($vehicle, 422, 'You do not have a vehicle registered in this category.');

        $claimed = Booking::where('id', $booking->id)
            ->where('status', 'scheduled_open')
            ->update(['driver_id' => $driver->id, 'vehicle_id' => $vehicle->id, 'status' => 'driver_assigned']);

        abort_if($claimed === 0, 422, 'This ride has already been accepted by another driver.');

        $booking = $booking->fresh(['customer', 'category']);

        $this->chat->ensureRideConversation($booking);

        $this->notifications->send(
            $booking->customer,
            'driver_accepted',
            'Driver accepted your ride',
            "{$driver->name} is confirmed for your scheduled ride to {$booking->destination_address}.",
            ['booking_id' => $booking->id],
        );

        $this->notifications->send(
            $driver,
            'ride_assigned',
            'Ride confirmed',
            "You're confirmed for the scheduled ride to {$booking->destination_address}.",
            ['booking_id' => $booking->id],
        );

        return response()->json(['data' => $booking]);
    }

    /** Records that this driver isn't interested — the ride stays open for every other eligible driver. */
    public function decline(Request $request, Booking $booking): JsonResponse
    {
        $driver = $this->driver($request);
        abort_if($booking->type !== 'scheduled', 404);
        abort_if($booking->status !== 'scheduled_open', 422, 'This ride is no longer open.');

        $booking->update([
            'rejected_driver_ids' => [...($booking->rejected_driver_ids ?? []), $driver->id],
        ]);

        return response()->json(['message' => 'Ride declined.']);
    }
}
