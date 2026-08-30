<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\VehicleCategory;
use App\Support\Locale;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class VehicleCategoryController extends Controller
{
    /**
     * Public catalog of vehicle categories, optionally priced for a given
     * distance/eta so both apps can render live fare estimates.
     */
    public function index(Request $request): JsonResponse
    {
        $distanceKm = (float) $request->query('distance_km', 0);
        $etaMinutes = (int) $request->query('eta_minutes', 0);
        $locale = Locale::resolve($request->header('Accept-Language'));

        $categories = VehicleCategory::orderBy('base_fare')->get()->map(function (VehicleCategory $category) use ($distanceKm, $etaMinutes, $locale) {
            $category->localizeFor($locale);

            return [
                'id' => $category->id,
                'name' => $category->name,
                'description' => $category->description,
                'image_url' => $category->image_url,
                'seats' => $category->seats,
                'ac' => $category->ac,
                'base_fare' => $category->base_fare,
                'per_km_rate' => $category->per_km_rate,
                'per_min_rate' => $category->per_min_rate,
                'estimated_fare' => $distanceKm > 0
                    ? $category->estimateFare($distanceKm, $etaMinutes)
                    : null,
            ];
        });

        return response()->json(['data' => $categories]);
    }
}
