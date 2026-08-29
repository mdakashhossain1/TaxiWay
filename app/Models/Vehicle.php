<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Vehicle extends Model
{
    protected $fillable = [
        'driver_id', 'vehicle_category_id', 'make_model', 'plate_number',
        'color', 'fuel_type', 'non_smoking', 'gps_enabled',
    ];

    protected function casts(): array
    {
        return [
            'non_smoking' => 'boolean',
            'gps_enabled' => 'boolean',
        ];
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(Driver::class);
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(VehicleCategory::class, 'vehicle_category_id');
    }

    public function media(): HasMany
    {
        return $this->hasMany(VehicleMedia::class);
    }
}
