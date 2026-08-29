<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class BulkBooking extends Model
{
    protected $fillable = [
        'customer_id', 'from_location', 'to_location', 'travel_date', 'travel_time',
        'passenger_count', 'vehicle_requirements', 'notes', 'contact_name', 'contact_phone', 'status',
    ];

    protected function casts(): array
    {
        return [
            'vehicle_requirements' => 'array',
            'travel_date' => 'date',
        ];
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function offers(): HasMany
    {
        return $this->hasMany(BulkBookingOffer::class);
    }
}
