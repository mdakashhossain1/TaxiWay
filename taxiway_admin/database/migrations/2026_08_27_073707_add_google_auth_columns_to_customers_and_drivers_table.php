<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            $table->string('google_id')->nullable()->unique()->after('email');
        });

        Schema::table('customers', function (Blueprint $table) {
            $table->string('phone', 15)->nullable()->change();
        });

        Schema::table('drivers', function (Blueprint $table) {
            $table->string('email')->nullable()->unique()->after('phone');
            $table->string('google_id')->nullable()->unique()->after('email');
        });

        Schema::table('drivers', function (Blueprint $table) {
            $table->string('phone', 15)->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('customers', function (Blueprint $table) {
            $table->dropColumn('google_id');
        });

        Schema::table('drivers', function (Blueprint $table) {
            $table->dropColumn(['email', 'google_id']);
        });

        Schema::table('customers', function (Blueprint $table) {
            $table->string('phone', 15)->nullable(false)->change();
        });

        Schema::table('drivers', function (Blueprint $table) {
            $table->string('phone', 15)->nullable(false)->change();
        });
    }
};
