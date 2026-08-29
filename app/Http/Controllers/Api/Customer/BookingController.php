<?php

namespace App\Http\Controllers\Api\Customer;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\Customer;
use App\Models\VehicleCategory;
use App\Services\PushNotificationService;
use App\Services\RideAllocationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function __construct(
        private readonly RideAllocationService $allocation,
        private readonly PushNotificationService $notifications,
    ) {}

    private function customer(Request $request): Customer
    {
        abort_unless($request->user() instanceof Customer, 403);

        return $request->user();
    }

    public function store(Request $request): JsonResponse
    {
        $customer = $this->customer($request);

        $data = $request->validate([
            'pickup_address' => ['required', 'string'],
            'pickup_lat' => ['required', 'numeric'],
            'pickup_lng' => ['required', 'numeric'],
            'destination_address' => ['required', 'string'],
            'destination_lat' => ['required', 'numeric'],
            'destination_lng' => ['required', 'numeric'],
            'vehicle_category_id' => ['required', 'exists:vehicle_categories,id'],
            'distance_km' => ['required', 'numeric', 'min:0'],
            'eta_minutes' => ['required', 'integer', 'min:0'],
            'payment_method' => ['required', 'in:upi,cash,card'],
        ]);

        // Real road distance can never be shorter than the straight-line distance
        // between the two points — fare is computed directly from distance_km
        // below, so without this check a client could report an arbitrarily
        // small distance and pay near-nothing for any real trip. 15% slack
        // covers GPS/rounding noise, not fraud.
        $straightLineKm = $this->haversineKm($data['pickup_lat'], $data['pickup_lng'], $data['destination_lat'], $data['destination_lng']);
        abort_if($data['distance_km'] < $straightLineKm * 0.85, 422, 'Reported distance is inconsistent with pickup/destination coordinates.');

        $category = VehicleCategory::findOrFail($data['vehicle_category_id']);

        $baseFare = (float) $category->base_fare;
        $distanceCharge = (float) $category->per_km_rate * $data['distance_km'];
        $timeCharge = (float) $category->per_min_rate * $data['eta_minutes'];

        $booking = Booking::create([
            ...$data,
            'customer_id' => $customer->id,
            'base_fare' => $baseFare,
            'distance_charge' => $distanceCharge,
            'time_charge' => $timeCharge,
            'total_fare' => round($baseFare + $distanceCharge + $timeCharge, 2),
            'status' => 'requested',
            'payment_status' => 'pending',
        ]);

        $this->allocation->offerNextDriver($booking);

        return response()->json(['data' => $booking->fresh(['driver', 'vehicle', 'category'])], 201);
    }

    private function haversineKm(float $lat1, float $lng1, float $lat2, float $lng2): float
    {
        $earthRadiusKm = 6371.0;
        $dLat = deg2rad($lat2 - $lat1);
        $dLng = deg2rad($lng2 - $lng1);
        $a = sin($dLat / 2) ** 2 + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * sin($dLng / 2) ** 2;

        return $earthRadiusKm * 2 * atan2(sqrt($a), sqrt(1 - $a));
    }

    public function index(Request $request): JsonResponse
    {
        $customer = $this->customer($request);

        $bookings = $customer->bookings()
            ->with(['driver', 'vehicle', 'category', 'review'])
            ->latest()
            ->get();

        return response()->json(['data' => $bookings]);
    }

    public function show(Request $request, Booking $booking): JsonResponse
    {
        $customer = $this->customer($request);
        abort_unless($booking->customer_id === $customer->id, 404);

        return response()->json(['data' => $booking->load(['driver', 'vehicle.media', 'category', 'review'])]);
    }

    public function cancel(Request $request, Booking $booking): JsonResponse
    {
        $customer = $this->customer($request);
        abort_unless($booking->customer_id === $customer->id, 404);
        abort_if(in_array($booking->status, ['completed', 'cancelled', 'failed'], true), 422, 'Booking can no longer be cancelled.');

        $driver = $booking->driver;

        $booking->update(['status' => 'cancelled']);

        if ($driver) {
            $this->notifications->send(
                $driver,
                'booking_cancelled',
                'Ride cancelled',
                "The customer cancelled the ride to {$booking->destination_address}.",
                ['booking_id' => $booking->id],
            );
        }

        return response()->json(['data' => $booking]);
    }
}
