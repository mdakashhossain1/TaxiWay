<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\ChatService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function __construct(private readonly ChatService $chat)
    {
    }

    public function customerToken(Request $request): JsonResponse
    {
        return $this->issueToken('customer_'.$request->user()->id);
    }

    public function driverToken(Request $request): JsonResponse
    {
        return $this->issueToken('driver_'.$request->user()->id);
    }

    private function issueToken(string $uid): JsonResponse
    {
        return response()->json(['data' => [
            'token' => $this->chat->mintToken($uid),
            'uid' => $uid,
            'support_conversation_id' => $this->chat->ensureSupportConversation($uid),
        ]]);
    }
}
