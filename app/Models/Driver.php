<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Laravel\Sanctum\HasApiTokens;

class Driver extends Model
{
    use HasApiTokens, HasFactory;

    protected $fillable = [
        'name', 'phone', 'email', 'google_id', 'fcm_token', 'photo_url', 'rating', 'total_trips', 'completion_rate',
        'years_experience', 'identity_verified', 'licence_verified', 'background_checked',
        'languages', 'operating_area', 'member_since', 'verification_status', 'preferred_locale',
    ];

    protected function casts(): array
    {
        return [
            'languages' => 'array',
            'member_since' => 'date',
            'identity_verified' => 'boolean',
            'licence_verified' => 'boolean',
            'background_checked' => 'boolean',
            'rating' => 'decimal:2',
            'completion_rate' => 'decimal:2',
        ];
    }

    public function isFullyVerified(): bool
    {
        return $this->identity_verified && $this->licence_verified && $this->background_checked;
    }

    public function vehicles(): HasMany
    {
        return $this->hasMany(Vehicle::class);
    }

    public function documents(): HasMany
    {
        return $this->hasMany(DriverDocument::class);
    }

    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }

    public function subscription(): HasOne
    {
        return $this->hasOne(DriverSubscription::class)->latestOfMany();
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }
}
