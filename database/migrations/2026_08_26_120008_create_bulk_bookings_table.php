<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bulk_bookings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained()->cascadeOnDelete();
            $table->string('from_location');
            $table->string('to_location');
            $table->date('travel_date');
            $table->time('travel_time');
            $table->unsignedInteger('passenger_count');
            $table->json('vehicle_requirements')->nullable();
            $table->text('notes')->nullable();
            $table->string('contact_name');
            $table->string('contact_phone', 15);
            $table->enum('status', ['submitted', 'offer_ready', 'confirmed', 'cancelled'])->default('submitted');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bulk_bookings');
    }
};
