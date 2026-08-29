<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('driver_subscription_plans', function (Blueprint $table) {
            $table->unsignedInteger('validity_days')->default(30)->after('rides_included');
            $table->text('description')->nullable()->after('validity_days');
            $table->boolean('is_active')->default(true)->after('description');
        });
    }

    public function down(): void
    {
        Schema::table('driver_subscription_plans', function (Blueprint $table) {
            $table->dropColumn(['validity_days', 'description', 'is_active']);
        });
    }
};
