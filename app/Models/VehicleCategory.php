<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class VehicleCategory extends Model
{
    protected $fillable = ['name', 'seats', 'ac', 'base_fare', 'per_km_rate', 'per_min_rate'];

    protected function casts(): array
    {
        return [
            'ac' => 'boolean',
            'base_fare' => 'decimal:2',
            'per_km_rate' => 'decimal:2',
            'per_min_rate' => 'decimal:2',
        ];
    }

    public function vehicles(): HasMany
    {
        return $this->hasMany(Vehicle::class);
    }

    public function estimateFare(float $distanceKm, int $etaMinutes): float
    {
        return round(
            (float) $this->base_fare
            + ((float) $this->per_km_rate * $distanceKm)
            + ((float) $this->per_min_rate * $etaMinutes),
            2
        );
    }
}
