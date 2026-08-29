<?php

namespace App\Services;

use App\Models\Customer;
use App\Models\Driver;
use App\Models\Notification;
use Illuminate\Support\Facades\Log;
use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Exception\Messaging\NotFound;
use Kreait\Firebase\Exception\MessagingException;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FcmNotification;
use Throwable;

/**
 * Sends an FCM push to a Customer/Driver and logs it to the `notifications`
 * table regardless of outcome — the log is an audit trail, not an in-app
 * inbox. General-purpose: any future event (admin broadcast, promo, support
 * reply) can call `send()` without touching this class.
 */
class PushNotificationService
{
    /**
     * @param  array<string, scalar>  $data  Extra payload for the client to act on (e.g. booking id) — values are cast to strings, as FCM requires.
     */
    public function send(Customer|Driver $recipient, string $type, string $title, string $body, array $data = []): void
    {
        $delivered = false;

        if ($recipient->fcm_token) {
            try {
                // Resolved lazily (not constructor-injected) so a missing/invalid
                // FIREBASE_CREDENTIALS degrades to "push skipped, logged" instead
                // of fataling every request that happens to touch a controller
                // that sends notifications.
                $messaging = app(Messaging::class);

                $message = CloudMessage::withTarget('token', $recipient->fcm_token)
                    ->withNotification(FcmNotification::create($title, $body))
                    ->withData(['type' => $type, ...array_map('strval', $data)]);

                $messaging->send($message);
                $delivered = true;
            } catch (NotFound) {
                // Token no longer registered on the device — stop retrying it.
                $recipient->update(['fcm_token' => null]);
            } catch (MessagingException|Throwable $e) {
                $recipientClass = $recipient::class;
                Log::warning("Push notification failed for {$recipientClass}#{$recipient->id}: {$e->getMessage()}");
            }
        }

        Notification::create([
            'notifiable_type' => $recipient::class,
            'notifiable_id' => $recipient->id,
            'type' => $type,
            'title' => $title,
            'body' => $body,
            'data' => $data,
            'delivered' => $delivered,
            'sent_at' => now(),
        ]);
    }
}
