<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('email_templates', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->string('subject');
            $table->string('heading');
            $table->text('body');
            $table->json('translations')->nullable();
            $table->timestamps();
        });

        DB::table('email_templates')->insert([
            'key' => 'driver_verified',
            'subject' => 'Your driver account is verified — start accepting rides',
            'heading' => 'You\'re verified, {driver_name}!',
            'body' => "Your documents have been reviewed and your account is now fully verified on {app_name}. You can open the driver app and start receiving ride requests right away.\n\nWelcome aboard — drive safe.",
            'translations' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('email_templates');
    }
};
