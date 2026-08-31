<?php

namespace App\Services;

use App\Models\Booking;
use App\Models\Vehicle;
use Illuminate\Support\Facades\Date;

/**
 * Driver matching for scheduled rides works differently from
 * RideAllocationService's real-time flow: instead of offering to one driver
 * at a time with a countdown, every currently-eligible driver is notified
 * at once and whoever accepts first (via ScheduledRideController::accept's
 * atomic conditional update) wins. This class only ever pushes
 * notifications — it never assigns a driver/vehicle itself.
 */
class ScheduledRideAllocationService
{
    public function __construct(private readonly PushNotificationService $notifications) {}

    /**
     * Notifies every driver eligible for this booking's vehicle category —
     * verified, not excluded (already declined), and not tied up with
     * another active booking. Same eligibility shape as
     * RideAllocationService::offerNextDriver(), but without ->first(): every
     * match gets notified, not just one.
     */
    public function broadcastToEligibleDrivers(Booking $booking): void
    {
        $excluded = $booking->rejected_driver_ids ?? [];

        $vehicles = Vehicle::where('vehicle_category_id', $booking->vehicle_category_id)
            ->whereHas('driver', fn ($q) => $q->where('verification_status', 'verified'))
            ->whereNotIn('driver_id', $excluded)
            ->whereDoesntHave(
                'driver.bookings',
                fn ($q) => $q->whereIn('status', Booking::ACTIVE_STATUSES)->where('id', '!=', $booking->id)
            )
            ->with('driver')
            ->get();

        $scheduledAt = $booking->scheduled_at?->format('d M, h:i A') ?? 'soon';
        $seats = $booking->category?->seats;
        $title = $seats ? "New scheduled ride — {$seats}-seater" : 'New scheduled ride available';

        // A driver with more than one vehicle in this category would
        // otherwise show up once per vehicle and get the same push twice.
        foreach ($vehicles->unique('driver_id') as $vehicle) {
            $this->notifications->send(
                $vehicle->driver,
                'scheduled_ride_available',
                $title,
                "Pickup at {$booking->pickup_address} on {$scheduledAt}. First to accept gets it.",
                ['booking_id' => $booking->id, 'scheduled_at' => $booking->scheduled_at?->toIso8601String()],
            );
        }

        $booking->update(['last_broadcast_at' => Date::now()]);
    }
}
