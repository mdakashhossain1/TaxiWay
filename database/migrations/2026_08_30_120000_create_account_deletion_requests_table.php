<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Keeps a record of who deleted their account and why, since the
     * customer row itself (and everything cascading from it) is gone by
     * the time this table is written to. `customer_id` deliberately has no
     * foreign key constraint — it must survive the customer row being
     * deleted. Accounts with no email on file go through a pending
     * (unconfirmed) row first, confirmed via a signed emailed link, so the
     * deletion can't be triggered by phone number alone.
     */
    public function up(): void
    {
        Schema::create('account_deletion_requests', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('customer_id')->nullable();
            $table->string('name')->nullable();
            $table->string('phone', 15);
            $table->string('email');
            $table->text('reason')->nullable();
            $table->string('locale', 5)->default('en');
            $table->timestamp('confirmed_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('account_deletion_requests');
    }
};
