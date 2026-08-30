<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AccountDeletionRequest extends Model
{
    protected $fillable = ['customer_id', 'name', 'phone', 'email', 'reason', 'locale', 'confirmed_at'];

    protected function casts(): array
    {
        return [
            'confirmed_at' => 'datetime',
        ];
    }
}
