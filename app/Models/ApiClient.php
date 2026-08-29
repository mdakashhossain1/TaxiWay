<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ApiClient extends Model
{
    protected $fillable = ['name', 'client_key', 'client_secret', 'is_active'];

    protected $hidden = ['client_secret'];

    protected function casts(): array
    {
        return [
            'client_secret' => 'encrypted',
            'is_active' => 'boolean',
        ];
    }
}
