<?php

namespace App\Services;

use App\Models\Booking;
use Illuminate\Support\Facades\Cache;
use Kreait\Firebase\Contract\Auth;

/**
 * Real-time chat rides on Firestore, with this service as the only writer
 * of `conversations/*` documents — clients (mobile apps + the admin support
 * inbox) can only read a conversation and append messages to it, per the
 * Firestore security rules, never create/modify the conversation itself.
 * That keeps a malicious client from fabricating a `participants` array to
 * eavesdrop on someone else's ride or support thread.
 */
class ChatService
{
    public function __construct(private readonly FirestoreService $firestore)
    {
    }

    /** Mints a Firebase Auth custom token so the client can sign in as $uid and satisfy Firestore's `request.auth.uid` checks. */
    public function mintToken(string $uid): string
    {
        return app(Auth::class)->createCustomToken($uid)->toString();
    }

    public function ensureRideConversation(Booking $booking): void
    {
        if (! $booking->customer_id || ! $booking->driver_id) {
            return;
        }

        $this->firestore->setDocument("conversations/ride_{$booking->id}", [
            'participants' => ["customer_{$booking->customer_id}", "driver_{$booking->driver_id}"],
            'type' => 'ride',
            'bookingId' => (string) $booking->id,
        ]);
    }

    /** @return string the conversation ID the caller should open */
    public function ensureSupportConversation(string $uid): string
    {
        $conversationId = "support_{$uid}";

        // The conversation doc's fields never change after creation, so
        // there's nothing to re-PATCH on repeat calls — this endpoint is hit
        // once per app session (on every chat-token mint), and without this
        // cache each of those would cost a synchronous Firestore round-trip
        // for a write that's a no-op after the very first call for a uid.
        $cacheKey = "support_conversation_exists:{$uid}";
        if (! Cache::get($cacheKey)) {
            $this->firestore->setDocument("conversations/{$conversationId}", [
                'participants' => [$uid, 'support_agent'],
                'type' => 'support',
            ]);
            Cache::forever($cacheKey, true);
        }

        return $conversationId;
    }
}
