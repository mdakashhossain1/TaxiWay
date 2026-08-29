<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BulkBookingOffer extends Model
{
    protected $fillable = ['bulk_booking_id', 'driver_id', 'vehicle_id', 'price', 'notes'];

    protected function casts(): array
    {
        return ['price' => 'decimal:2'];
    }

    public function bulkBooking(): BelongsTo
    {
        return $this->belongsTo(BulkBooking::class);
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(Driver::class);
    }

    public function vehicle(): BelongsTo
    {
        return $this->belongsTo(Vehicle::class);
    }
}
