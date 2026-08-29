<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SubscriptionPayment extends Model
{
    protected $fillable = ['driver_subscription_id', 'amount', 'paid_on', 'payment_method', 'next_renewal'];

    protected function casts(): array
    {
        return [
            'amount' => 'decimal:2',
            'paid_on' => 'date',
            'next_renewal' => 'date',
        ];
    }

    public function subscription(): BelongsTo
    {
        return $this->belongsTo(DriverSubscription::class, 'driver_subscription_id');
    }
}
