<?php

namespace App\Http\Controllers\Api\Customer;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    /**
     * Completes registration for a newly-created customer (profile_setup_screen
     * in taxiway) — verify-otp already created the bare record with a
     * placeholder name.
     */
    public function update(Request $request): JsonResponse
    {
        abort_unless($request->user() instanceof Customer, 403);
        $customer = $request->user();

        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['nullable', 'email', 'max:255'],
        ]);

        $customer->update($data);

        return response()->json(['data' => $customer]);
    }
}
