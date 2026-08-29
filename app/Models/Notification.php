<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

/**
 * Audit log of every push sent via PushNotificationService — not an in-app
 * inbox (no read state, no listing endpoint), just a record of what was
 * sent, to whom, and whether delivery to FCM succeeded.
 */
class Notification extends Model
{
    protected $fillable = ['notifiable_type', 'notifiable_id', 'type', 'title', 'body', 'data', 'delivered', 'sent_at'];

    protected function casts(): array
    {
        return [
            'data' => 'array',
            'delivered' => 'boolean',
            'sent_at' => 'datetime',
        ];
    }

    public function notifiable(): MorphTo
    {
        return $this->morphTo();
    }
}
