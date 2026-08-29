<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Services\ChatService;
use Illuminate\Http\JsonResponse;
use Illuminate\View\View;

class SupportChatController extends Controller
{
    /** Every support conversation includes this fixed identity as the second participant — one shared inbox for the whole admin team, not a token per admin user. */
    public const AGENT_UID = 'support_agent';

    public function __construct(private readonly ChatService $chat)
    {
    }

    public function index(): View
    {
        return view('pages.admin.settings.support-chat', [
            'title' => 'Support Chat',
            'firebaseProjectId' => config('services.firebase.project_id'),
            'firebaseWebApiKey' => config('services.firebase.web_api_key'),
        ]);
    }

    public function token(): JsonResponse
    {
        return response()->json(['data' => [
            'token' => $this->chat->mintToken(self::AGENT_UID),
            'uid' => self::AGENT_UID,
        ]]);
    }
}
