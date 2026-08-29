<?php

namespace App\Services;

use App\Jobs\ExpireRideOffer;
use App\Models\Booking;
use App\Models\Vehicle;

/**
 * Shared by the customer's booking flow (first offer) and the driver's
 * reject endpoint (re-offer) — anywhere a booking needs to go looking for
 * its next candidate driver.
 */
class RideAllocationService
{
    private const OFFER_WINDOW_SECONDS = 20;

    public function __construct(private readonly PushNotificationService $notifications) {}

    /**
     * Offers the booking to the next eligible driver (verified, has a
     * vehicle in the requested category, not currently tied up with another
     * active booking, and not already in `rejected_driver_ids`), and starts
     * their acceptance countdown via a delayed `ExpireRideOffer` job. Falls
     * back to "allocating" — unassigned, to be retried later — if nobody is
     * currently eligible, same as the naive best-effort behavior this
     * replaced.
     */
    public function offerNextDriver(Booking $booking): void
    {
        $excluded = $booking->rejected_driver_ids ?? [];

        $vehicle = Vehicle::where('vehicle_category_id', $booking->vehicle_category_id)
            ->whereHas('driver', fn ($q) => $q->where('verification_status', 'verified'))
            ->whereNotIn('driver_id', $excluded)
            ->whereDoesntHave(
                'driver.bookings',
                fn ($q) => $q->whereIn('status', Booking::ACTIVE_STATUSES)->where('id', '!=', $booking->id)
            )
            ->with('driver')
            ->first();

        if (! $vehicle) {
            $booking->update(['status' => 'allocating', 'driver_id' => null, 'vehicle_id' => null, 'offer_expires_at' => null]);

            return;
        }

        $expiresAt = now()->addSeconds(self::OFFER_WINDOW_SECONDS);

        $booking->update([
            'driver_id' => $vehicle->driver_id,
            'vehicle_id' => $vehicle->id,
            'status' => 'driver_offered',
            'offer_expires_at' => $expiresAt,
        ]);

        $this->notifications->send(
            $vehicle->driver,
            'ride_offer',
            'New ride available',
            "Pickup at {$booking->pickup_address}",
            ['booking_id' => $booking->id, 'expires_at' => $expiresAt->toIso8601String()],
        );

        ExpireRideOffer::dispatch($booking->id)->delay($expiresAt);
    }
}
