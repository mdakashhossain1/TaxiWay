<?php

namespace App\Console\Commands;

use App\Models\Booking;
use App\Services\ScheduledRideAllocationService;
use Illuminate\Console\Command;

/**
 * "Keep retrying past the scheduled time" — re-notifies eligible drivers for
 * any scheduled ride nobody has accepted yet, throttled to once per 15
 * minutes per booking (via last_broadcast_at) so a long-unfilled ride
 * doesn't spam the same drivers every run. Registered in routes/console.php;
 * only actually fires as often as the external cron pinger hits
 * GET /cron/run (see CronController) — same dependency the existing
 * queue:work drain already has.
 */
class RebroadcastScheduledRides extends Command
{
    protected $signature = 'rides:rebroadcast-scheduled';

    protected $description = 'Re-notify eligible drivers for scheduled rides nobody has accepted yet';

    public function handle(ScheduledRideAllocationService $allocation): int
    {
        $bookings = Booking::where('status', 'scheduled_open')
            ->where(fn ($q) => $q->whereNull('last_broadcast_at')->orWhere('last_broadcast_at', '<', now()->subMinutes(15)))
            ->get();

        foreach ($bookings as $booking) {
            $allocation->broadcastToEligibleDrivers($booking);
        }

        $this->info("Rebroadcast {$bookings->count()} scheduled ride(s).");

        return self::SUCCESS;
    }
}
