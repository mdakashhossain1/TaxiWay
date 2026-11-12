<?php

namespace App\Services;

use App\Jobs\ExpireRideOffer;
use App\Models\Booking;
use App\Models\Driver;
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

        $eligible = Vehicle::query()
            ->where('vehicle_category_id', $booking->vehicle_category_id)
            ->whereHas('driver', fn ($q) => $q->where('verification_status', 'verified'))
            ->whereNotIn('driver_id', $excluded)
            ->whereDoesntHave(
                'driver.bookings',
                fn ($q) => $q->whereIn('status', Booking::ACTIVE_STATUSES)->where('id', '!=', $booking->id)
            )
            ->with('driver');

        $vehicle = $this->nearestInPickupCells($booking, $eligible)
            // Fall back to any eligible driver when no one is in the pickup's
            // H3 cells (or the rider app didn't send cells) — same best-effort
            // behavior as before H3 ranking existed.
            ?? $eligible->first();

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

    /**
     * Shortlists eligible vehicles whose driver is currently in one of the
     * pickup's H3 cells, then returns the one whose driver is physically
     * closest to the pickup. Returns null when the booking carries no pickup
     * cells or none of the shortlisted drivers are usable.
     *
     * @param  \Illuminate\Database\Eloquent\Builder<Vehicle>  $eligible
     */
    private function nearestInPickupCells(Booking $booking, $eligible): ?Vehicle
    {
        $cells = $booking->pickup_h3_cells;
        if (empty($cells)) {
            return null;
        }

        return (clone $eligible)
            ->whereHas('driver', fn ($q) => $q->whereIn('current_h3_r8', $cells))
            ->get()
            ->sortBy(fn (Vehicle $vehicle) => $this->distanceToPickupKm($booking, $vehicle->driver))
            ->first();
    }

    private function distanceToPickupKm(Booking $booking, ?Driver $driver): float
    {
        if (! $driver || $driver->current_latitude === null || $driver->current_longitude === null) {
            return PHP_FLOAT_MAX;
        }

        $earthRadiusKm = 6371.0;
        $dLat = deg2rad((float) $driver->current_latitude - (float) $booking->pickup_lat);
        $dLng = deg2rad((float) $driver->current_longitude - (float) $booking->pickup_lng);
        $a = sin($dLat / 2) ** 2
            + cos(deg2rad((float) $booking->pickup_lat)) * cos(deg2rad((float) $driver->current_latitude)) * sin($dLng / 2) ** 2;

        return $earthRadiusKm * 2 * atan2(sqrt($a), sqrt(1 - $a));
    }
}
