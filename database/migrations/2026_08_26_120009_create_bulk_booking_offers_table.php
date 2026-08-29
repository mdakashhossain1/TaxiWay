<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bulk_booking_offers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('bulk_booking_id')->constrained()->cascadeOnDelete();
            $table->foreignId('driver_id')->constrained();
            $table->foreignId('vehicle_id')->constrained();
            $table->decimal('price', 10, 2);
            $table->text('notes')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bulk_booking_offers');
    }
};
