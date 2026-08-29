<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class DriverDocument extends Model
{
    protected $fillable = ['driver_id', 'label', 'path', 'original_name'];

    public function driver(): BelongsTo
    {
        return $this->belongsTo(Driver::class);
    }
}
