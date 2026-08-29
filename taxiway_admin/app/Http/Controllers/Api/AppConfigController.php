<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class AppConfigController extends Controller
{
    /**
     * Public app-wide config, e.g. the support number "Contact Support" /
     * "Call Office" buttons dial — admin-editable without an app release.
     */
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => [
                'support_contact_number' => config('services.support.contact_number'),
            ],
        ]);
    }
}
