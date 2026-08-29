<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('driver_subscriptions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('driver_id')->constrained()->cascadeOnDelete();
            $table->foreignId('driver_subscription_plan_id')->constrained();
            $table->unsignedInteger('rides_used')->default(0);
            $table->date('start_date');
            $table->date('renewal_date');
            $table->enum('status', [
                'active', 'expiring_soon', 'expired', 'quota_exhausted', 'payment_pending', 'suspended',
            ])->default('active');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('driver_subscriptions');
    }
};
