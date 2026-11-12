<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * H3 geospatial indexing for driver allocation. The driver app computes its
 * current H3 cell (Uber's open-source hex index) and sends it with each
 * location update; the rider app sends the pickup's cell + surrounding ring
 * with a booking. Allocation then shortlists candidates with a single indexed
 * `WHERE current_h3_r8 IN (...)` before ranking by true distance — no H3
 * library is needed on the PHP side.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('drivers', function (Blueprint $table) {
            $table->string('current_h3_r8', 16)->nullable()->index()->after('location_updated_at');
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->json('pickup_h3_cells')->nullable()->after('pickup_lng');
        });
    }

    public function down(): void
    {
        Schema::table('drivers', function (Blueprint $table) {
            $table->dropColumn('current_h3_r8');
        });

        Schema::table('bookings', function (Blueprint $table) {
            $table->dropColumn('pickup_h3_cells');
        });
    }
};
