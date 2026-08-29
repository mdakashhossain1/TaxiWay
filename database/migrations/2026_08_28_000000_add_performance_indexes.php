<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Indexes for columns filtered on the real-time ride-matching hot path
 * (RideAllocationService, run synchronously on every booking creation and
 * driver rejection) and the admin/driver list screens — invisible on a small
 * dataset, increasingly costly as bookings/drivers grow.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->index('status');
            $table->index(['status', 'driver_id']);
            $table->index('created_at');
        });

        Schema::table('drivers', function (Blueprint $table) {
            $table->index('verification_status');
        });

        Schema::table('driver_subscriptions', function (Blueprint $table) {
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::table('bookings', function (Blueprint $table) {
            $table->dropIndex(['status']);
            $table->dropIndex(['status', 'driver_id']);
            $table->dropIndex(['created_at']);
        });

        Schema::table('drivers', function (Blueprint $table) {
            $table->dropIndex(['verification_status']);
        });

        Schema::table('driver_subscriptions', function (Blueprint $table) {
            $table->dropIndex(['status']);
        });
    }
};
