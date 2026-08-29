<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Symfony\Component\HttpFoundation\Response;

/**
 * HTTP-triggerable equivalent of `php artisan schedule:run`, for an external
 * server that can only make HTTP requests — no shell/crontab access to this
 * one. Protected by a shared secret (CRON_SECRET) rather than session auth,
 * since the caller has no admin login, just a token issued out of band.
 *
 * Returns a generic 404 on a bad/missing token rather than 403 — same
 * reasoning as VerifyHmacSignature's generic reject(): don't give a caller
 * any signal about *why* it failed, so there's no oracle for guessing the
 * secret.
 */
class CronController extends Controller
{
    public function run(Request $request): JsonResponse
    {
        $secret = config('services.cron.secret');
        $token = (string) $request->query('token');

        if (! $secret || ! hash_equals($secret, $token)) {
            return response()->json(['message' => 'Not found.'], Response::HTTP_NOT_FOUND);
        }

        Artisan::call('schedule:run');

        return response()->json(['ran_at' => now()->toIso8601String(), 'output' => Artisan::output()]);
    }
}
