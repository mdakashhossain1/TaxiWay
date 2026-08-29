<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vehicles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('driver_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('vehicle_category_id')->constrained()->cascadeOnDelete();
            $table->string('make_model');
            $table->string('plate_number')->unique();
            $table->string('color')->nullable();
            $table->string('fuel_type')->default('petrol');
            $table->boolean('non_smoking')->default(true);
            $table->boolean('gps_enabled')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vehicles');
    }
};
