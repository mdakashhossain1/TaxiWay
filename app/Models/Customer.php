<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Laravel\Sanctum\HasApiTokens;

class Customer extends Model
{
    use HasApiTokens, HasFactory;

    protected $fillable = ['name', 'phone', 'email', 'photo_url', 'google_id', 'fcm_token'];

    public function bookings(): HasMany
    {
        return $this->hasMany(Booking::class);
    }

    public function bulkBookings(): HasMany
    {
        return $this->hasMany(BulkBooking::class);
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }

    public function supportTickets(): HasMany
    {
        return $this->hasMany(SupportTicket::class);
    }
}
