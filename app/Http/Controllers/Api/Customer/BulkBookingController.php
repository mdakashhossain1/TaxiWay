<?php

namespace App\Http\Controllers\Api\Customer;

use App\Http\Controllers\Controller;
use App\Models\BulkBooking;
use App\Models\BulkBookingOffer;
use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BulkBookingController extends Controller
{
    private function customer(Request $request): Customer
    {
        abort_unless($request->user() instanceof Customer, 403);

        return $request->user();
    }

    public function store(Request $request): JsonResponse
    {
        $customer = $this->customer($request);

        $data = $request->validate([
            'from_location' => ['required', 'string'],
            'to_location' => ['required', 'string'],
            'travel_date' => ['required', 'date'],
            'travel_time' => ['required'],
            'passenger_count' => ['required', 'integer', 'min:1'],
            'vehicle_requirements' => ['nullable', 'array'],
            'notes' => ['nullable', 'string'],
            'contact_name' => ['required', 'string'],
            'contact_phone' => ['required', 'digits:10'],
        ]);

        $bulkBooking = BulkBooking::create([
            ...$data,
            'customer_id' => $customer->id,
            'status' => 'submitted',
        ]);

        return response()->json(['data' => $bulkBooking], 201);
    }

    public function show(Request $request, BulkBooking $bulkBooking): JsonResponse
    {
        $customer = $this->customer($request);
        abort_unless($bulkBooking->customer_id === $customer->id, 404);

        return response()->json(['data' => $bulkBooking->load('offers.driver', 'offers.vehicle')]);
    }

    public function confirm(Request $request, BulkBooking $bulkBooking): JsonResponse
    {
        $customer = $this->customer($request);
        abort_unless($bulkBooking->customer_id === $customer->id, 404);
        abort_unless($bulkBooking->status === 'offer_ready', 422, 'This request has no offer ready to confirm.');

        $data = $request->validate([
            'offer_id' => ['required', 'exists:bulk_booking_offers,id'],
        ]);

        $offer = BulkBookingOffer::findOrFail($data['offer_id']);
        abort_unless($offer->bulk_booking_id === $bulkBooking->id, 422);

        $bulkBooking->update(['status' => 'confirmed']);

        return response()->json(['data' => $bulkBooking->load('offers.driver', 'offers.vehicle')]);
    }
}
