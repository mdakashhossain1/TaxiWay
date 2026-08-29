<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class DriverSubscription extends Model
{
    protected $fillable = [
        'driver_id', 'driver_subscription_plan_id', 'rides_used', 'start_date', 'renewal_date', 'status',
    ];

    protected function casts(): array
    {
        return [
            'start_date' => 'date',
            'renewal_date' => 'date',
        ];
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(Driver::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(DriverSubscriptionPlan::class, 'driver_subscription_plan_id');
    }

    public function payments(): HasMany
    {
        return $this->hasMany(SubscriptionPayment::class);
    }

    public function ridesRemaining(): int
    {
        return max(0, $this->plan->rides_included - $this->rides_used);
    }
}
