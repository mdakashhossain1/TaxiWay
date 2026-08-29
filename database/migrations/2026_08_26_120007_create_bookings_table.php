<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $table->foreignId('driver_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('vehicle_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('vehicle_category_id')->constrained();

            $table->string('pickup_address');
            $table->decimal('pickup_lat', 10, 7);
            $table->decimal('pickup_lng', 10, 7);
            $table->string('destination_address');
            $table->decimal('destination_lat', 10, 7);
            $table->decimal('destination_lng', 10, 7);

            $table->decimal('distance_km', 8, 2)->default(0);
            $table->unsignedInteger('eta_minutes')->default(0);

            $table->decimal('base_fare', 10, 2)->default(0);
            $table->decimal('distance_charge', 10, 2)->default(0);
            $table->decimal('time_charge', 10, 2)->default(0);
            $table->decimal('total_fare', 10, 2)->default(0);

            $table->enum('status', [
                'requested', 'allocating', 'driver_assigned', 'driver_en_route',
                'driver_arrived', 'ride_started', 'ride_in_progress',
                'completed', 'cancelled', 'failed',
            ])->default('requested');

            $table->enum('payment_method', ['upi', 'cash', 'card'])->default('cash');
            $table->enum('payment_status', ['pending', 'paid'])->default('pending');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
