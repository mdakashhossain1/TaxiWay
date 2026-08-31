<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Adds scheduled-ride support alongside today's instant bookings.
     * `scheduled_open` is a new status meaning "open to any eligible driver,
     * nobody has accepted yet" — distinct from `driver_offered` (offered to
     * exactly one driver with a countdown). Once any driver accepts a
     * scheduled ride it moves straight into the existing `driver_assigned`
     * status, so every downstream code path (chat, notifications,
     * markCompleted, reviews) keeps working unmodified.
     */
    public function up(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->enum('type', ['instant', 'scheduled'])->default('instant')->after('vehicle_category_id');
            $table->timestamp('scheduled_at')->nullable()->after('type');
            $table->timestamp('last_broadcast_at')->nullable()->after('offer_expires_at');
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->enum('status', [
                'requested', 'allocating', 'scheduled_open', 'driver_offered', 'driver_assigned', 'driver_en_route',
                'driver_arrived', 'ride_started', 'ride_in_progress',
                'completed', 'cancelled', 'failed',
            ])->default('requested')->change();
        });
    }

    public function down(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn(['type', 'scheduled_at', 'last_broadcast_at']);
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->enum('status', [
                'requested', 'allocating', 'driver_offered', 'driver_assigned', 'driver_en_route',
                'driver_arrived', 'ride_started', 'ride_in_progress',
                'completed', 'cancelled', 'failed',
            ])->default('requested')->change();
        });
    }
};
