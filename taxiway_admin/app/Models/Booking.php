<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Booking extends Model
{
    protected $fillable = [
        'customer_id', 'driver_id', 'vehicle_id', 'vehicle_category_id',
        'pickup_address', 'pickup_lat', 'pickup_lng',
        'destination_address', 'destination_lat', 'destination_lng',
        'distance_km', 'eta_minutes',
        'base_fare', 'distance_charge', 'time_charge', 'total_fare',
        'status', 'offer_expires_at', 'rejected_driver_ids', 'payment_method', 'payment_status',
    ];

    protected function casts(): array
    {
        return [
            'pickup_lat' => 'decimal:7',
            'pickup_lng' => 'decimal:7',
            'destination_lat' => 'decimal:7',
            'destination_lng' => 'decimal:7',
            'distance_km' => 'decimal:2',
            'base_fare' => 'decimal:2',
            'distance_charge' => 'decimal:2',
            'time_charge' => 'decimal:2',
            'total_fare' => 'decimal:2',
            'offer_expires_at' => 'datetime',
            'rejected_driver_ids' => 'array',
        ];
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(Driver::class);
    }

    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(VehicleCategory::class, 'vehicle_category_id');
    }

    public function review(): HasOne
    {
        return $this->hasOne(Review::class);
    }

    /** Any status that should block a driver from receiving another offer. */
    public const ACTIVE_STATUSES = [
        'requested', 'allocating', 'driver_offered', 'driver_assigned', 'driver_en_route', 'driver_arrived', 'ride_started', 'ride_in_progress',
    ];

    /** Statuses meaning a driver has actually accepted — used for "next/upcoming ride" views, as opposed to a still-pending offer. */
    public const CONFIRMED_STATUSES = [
        'driver_assigned', 'driver_en_route', 'driver_arrived', 'ride_started', 'ride_in_progress',
    ];
}
