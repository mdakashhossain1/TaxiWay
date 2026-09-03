<?php

namespace App\Http\Controllers\Api\Driver;

use App\Http\Controllers\Controller;
use App\Models\Driver;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class LocationController extends Controller
{
    /** Called periodically by the driver app while it's in the foreground. */
    public function update(Request $request): JsonResponse
    {
        abort_unless($request->user() instanceof Driver, 403);
        $driver = $request->user();

        $validated = $request->validate([
            'latitude' => ['required', 'numeric', 'between:-90,90'],
            'longitude' => ['required', 'numeric', 'between:-180,180'],
        ]);

        $driver->update([
            'current_latitude' => $validated['latitude'],
            'current_longitude' => $validated['longitude'],
            'location_updated_at' => now(),
        ]);

        return response()->json(['message' => 'Location updated.']);
    }
}
