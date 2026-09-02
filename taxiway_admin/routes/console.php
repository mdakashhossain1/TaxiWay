<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// Shared hosting can't run a persistent `queue:work` daemon, so this is the
// standard workaround: process whatever's queued (e.g. DriverVerifiedMail)
// once a minute, stopping as soon as the queue is empty rather than idling.
// --max-time is a safety net in case a job hangs, so this can't overlap into
// the next minute's run. Triggered once a minute via GET /cron/run?token=...
// (see CronController) from an external server, not a local crontab.
Schedule::command('queue:work --stop-when-empty --max-time=50')
    ->everyMinute()
    ->withoutOverlapping();

// Keeps re-notifying eligible drivers for scheduled rides nobody has
// accepted yet — see RebroadcastScheduledRides for the per-booking
// 15-minute throttle. Same "only fires if the external cron pinger keeps
// hitting /cron/run" dependency as the queue drain above.
Schedule::command('rides:rebroadcast-scheduled')
    ->everyFiveMinutes()
    ->withoutOverlapping();

Schedule::command('cache:prune-expired-database')
    ->hourly()
    ->withoutOverlapping();
