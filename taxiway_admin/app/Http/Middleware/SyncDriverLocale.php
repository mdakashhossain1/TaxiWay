<?php

namespace App\Http\Middleware;

use App\Models\Driver;
use App\Support\Locale;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Piggybacks on the Accept-Language header taxiwaydriver already sends on every
 * request, so the backend knows which language to send admin-triggered
 * notifications (e.g. the verification email) in — the app never explicitly
 * reports its language otherwise.
 */
class SyncDriverLocale
{
    public function handle(Request $request, Closure $next): Response
    {
        $driver = $request->user();

        if ($driver instanceof Driver) {
            $locale = Locale::resolve($request->header('Accept-Language'));

            if ($driver->preferred_locale !== $locale) {
                $driver->update(['preferred_locale' => $locale]);
            }
        }

        return $next($request);
    }
}
