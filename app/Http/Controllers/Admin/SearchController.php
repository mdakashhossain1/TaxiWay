<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\BulkBooking;
use App\Models\Customer;
use App\Models\Driver;
use App\Models\DriverSubscription;
use App\Models\Vehicle;
use App\Models\VehicleCategory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class SearchController extends Controller
{
    private const PER_GROUP = 5;

    public function index(Request $request): JsonResponse
    {
        $q = trim((string) $request->query('q', ''));

        if (mb_strlen($q) < 2) {
            return response()->json(['results' => []]);
        }

        $results = collect()
            ->merge($this->drivers($q))
            ->merge($this->vehicles($q))
            ->merge($this->customers($q))
            ->merge($this->bookings($q))
            ->merge($this->vehicleCategories($q))
            ->merge($this->driverSubscriptions($q))
            ->merge($this->bulkBookings($q));

        return response()->json(['results' => $results->values()]);
    }

    private function drivers(string $q)
    {
        return Driver::where('name', 'like', "%{$q}%")->orWhere('phone', 'like', "%{$q}%")
            ->limit(self::PER_GROUP)->get()
            ->map(fn (Driver $d) => [
                'group' => 'Drivers',
                'title' => $d->name,
                'subtitle' => $d->phone,
                'url' => route('drivers.show', $d),
            ]);
    }

    private function vehicles(string $q)
    {
        return Vehicle::where('make_model', 'like', "%{$q}%")->orWhere('plate_number', 'like', "%{$q}%")
            ->limit(self::PER_GROUP)->get()
            ->map(fn (Vehicle $v) => [
                'group' => 'Vehicles',
                'title' => $v->make_model,
                'subtitle' => $v->plate_number,
                'url' => route('vehicles.edit', $v),
            ]);
    }

    private function customers(string $q)
    {
        return Customer::where('name', 'like', "%{$q}%")
            ->orWhere('phone', 'like', "%{$q}%")
            ->orWhere('email', 'like', "%{$q}%")
            ->limit(self::PER_GROUP)->get()
            ->map(fn (Customer $c) => [
                'group' => 'Customers',
                'title' => $c->name,
                'subtitle' => $c->phone,
                'url' => route('customers.show', $c),
            ]);
    }

    private function bookings(string $q)
    {
        $query = Booking::with('customer')
            ->where(fn ($w) => $w->where('pickup_address', 'like', "%{$q}%")
                ->orWhere('destination_address', 'like', "%{$q}%"));

        if (ctype_digit($q)) {
            $query->orWhere('id', (int) $q);
        }

        return $query->limit(self::PER_GROUP)->get()
            ->map(fn (Booking $b) => [
                'group' => 'Bookings',
                'title' => '#'.$b->id.' · '.Str::limit($b->pickup_address, 20).' → '.Str::limit($b->destination_address, 20),
                'subtitle' => $b->customer->name,
                'url' => route('bookings.show', $b),
            ]);
    }

    private function vehicleCategories(string $q)
    {
        return VehicleCategory::where('name', 'like', "%{$q}%")
            ->limit(self::PER_GROUP)->get()
            ->map(fn (VehicleCategory $c) => [
                'group' => 'Vehicle Categories',
                'title' => $c->name,
                'subtitle' => null,
                'url' => route('vehicle-categories.edit', $c),
            ]);
    }

    private function driverSubscriptions(string $q)
    {
        return DriverSubscription::with('driver')
            ->whereHas('driver', fn ($d) => $d->where('name', 'like', "%{$q}%"))
            ->limit(self::PER_GROUP)->get()
            ->map(fn (DriverSubscription $s) => [
                'group' => 'Subscriptions',
                'title' => $s->driver->name.'\'s subscription',
                'subtitle' => $s->status,
                'url' => route('driver-subscriptions.show', $s),
            ]);
    }

    private function bulkBookings(string $q)
    {
        return BulkBooking::with('customer')
            ->where(fn ($w) => $w->where('from_location', 'like', "%{$q}%")
                ->orWhere('to_location', 'like', "%{$q}%")
                ->orWhere('contact_name', 'like', "%{$q}%"))
            ->limit(self::PER_GROUP)->get()
            ->map(fn (BulkBooking $b) => [
                'group' => 'Bulk Bookings',
                'title' => Str::limit($b->from_location, 18).' → '.Str::limit($b->to_location, 18),
                'subtitle' => $b->contact_name,
                'url' => route('bulk-bookings.show', $b),
            ]);
    }
}
