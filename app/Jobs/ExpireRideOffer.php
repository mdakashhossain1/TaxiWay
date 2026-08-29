<?php

namespace App\Jobs;

use App\Models\Booking;
use App\Services\RideAllocationService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

/**
 * Fires once a ride offer's countdown runs out. If the driver still hasn't
 * accepted, treats it like a rejection (excludes them, re-offers to the
 * next candidate) — driven off `offer_expires_at` rather than blind trust in
 * the delay, so a since-superseded offer (already accepted/rejected/a newer
 * offer entirely) is a safe no-op.
 */
class ExpireRideOffer implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(private readonly int $bookingId) {}

    public function handle(RideAllocationService $allocation): void
    {
        $booking = Booking::find($this->bookingId);

        if (! $booking || $booking->status !== 'driver_offered') {
            return;
        }

        if ($booking->offer_expires_at && $booking->offer_expires_at->isFuture()) {
            return;
        }

        $booking->update([
            'rejected_driver_ids' => [...($booking->rejected_driver_ids ?? []), $booking->driver_id],
            'driver_id' => null,
            'vehicle_id' => null,
        ]);

        $allocation->offerNextDriver($booking->fresh());
    }
}
