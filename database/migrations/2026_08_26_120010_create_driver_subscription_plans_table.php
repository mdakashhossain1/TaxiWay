<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('driver_subscription_plans', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->decimal('price_per_month', 10, 2);
            $table->unsignedInteger('rides_included');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('driver_subscription_plans');
    }
};
