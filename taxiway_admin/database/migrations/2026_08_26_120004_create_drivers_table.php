<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('drivers', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('phone', 15)->unique();
            $table->string('photo_url')->nullable();
            $table->decimal('rating', 3, 2)->default(5.0);
            $table->unsignedInteger('total_trips')->default(0);
            $table->decimal('completion_rate', 5, 2)->default(100);
            $table->unsignedTinyInteger('years_experience')->default(0);
            $table->boolean('identity_verified')->default(false);
            $table->boolean('licence_verified')->default(false);
            $table->boolean('background_checked')->default(false);
            $table->json('languages')->nullable();
            $table->string('operating_area')->nullable();
            $table->date('member_since')->nullable();
            $table->enum('verification_status', ['verified', 'pending', 'suspended'])->default('pending');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('drivers');
    }
};
