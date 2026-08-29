<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->timestamp('offer_expires_at')->nullable()->after('status');
            $table->json('rejected_driver_ids')->nullable()->after('offer_expires_at');
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->enum('status', [
                'requested', 'allocating', 'driver_offered', 'driver_assigned', 'driver_en_route',
                'driver_arrived', 'ride_started', 'ride_in_progress',
                'completed', 'cancelled', 'failed',
            ])->default('requested')->change();
        });
    }

    public function down(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn(['offer_expires_at', 'rejected_driver_ids']);
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->enum('status', [
                'requested', 'allocating', 'driver_assigned', 'driver_en_route',
                'driver_arrived', 'ride_started', 'ride_in_progress',
                'completed', 'cancelled', 'failed',
            ])->default('requested')->change();
        });
    }
};
