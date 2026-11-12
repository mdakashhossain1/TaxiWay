<?php

use App\Jobs\ExpireRideOffer;
use App\Models\Booking;
use App\Models\Customer;
use App\Models\Driver;
use App\Models\Vehicle;
use App\Models\VehicleCategory;
use App\Services\RideAllocationService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Queue;

uses(RefreshDatabase::class);

beforeEach(function () {
    Queue::fake();
});

function allocationCategory(): VehicleCategory
{
    return VehicleCategory::create([
        'name' => 'Sedan',
        'seats' => 4,
        'ac' => true,
        'base_fare' => 100,
        'per_km_rate' => 12,
        'per_min_rate' => 1,
    ]);
}

function allocationDriver(VehicleCategory $category, string $phone, float $lat, float $lng, ?string $cell): Driver
{
    $driver = Driver::create([
        'name' => "Driver {$phone}",
        'phone' => $phone,
        'verification_status' => 'verified',
        'current_latitude' => $lat,
        'current_longitude' => $lng,
        'current_h3_r8' => $cell,
    ]);

    Vehicle::create([
        'driver_id' => $driver->id,
        'vehicle_category_id' => $category->id,
        'make_model' => 'Swift',
        'plate_number' => "BR01-{$phone}",
    ]);

    return $driver;
}

function allocationBooking(VehicleCategory $category, ?array $pickupCells, array $rejected = []): Booking
{
    $customer = Customer::create(['name' => 'Rider', 'phone' => '9'.random_int(100000000, 999999999)]);

    return Booking::create([
        'customer_id' => $customer->id,
        'vehicle_category_id' => $category->id,
        'pickup_address' => 'Mithapur, Patna',
        'pickup_lat' => 25.6000000,
        'pickup_lng' => 85.1000000,
        'pickup_h3_cells' => $pickupCells,
        'destination_address' => 'Patna Junction',
        'destination_lat' => 25.6200000,
        'destination_lng' => 85.1400000,
        'status' => 'requested',
        'rejected_driver_ids' => $rejected,
    ]);
}

function allocate(Booking $booking): Booking
{
    app(RideAllocationService::class)->offerNextDriver($booking);

    return $booking->refresh();
}

test('offers the booking to the nearest driver among those in the pickup H3 cells', function () {
    $category = allocationCategory();
    $near = allocationDriver($category, '9000000001', 25.6010, 85.1010, 'cell-a');
    allocationDriver($category, '9000000002', 25.6500, 85.1500, 'cell-b');
    allocationDriver($category, '9000000003', 25.6001, 85.1001, 'cell-outside');

    $booking = allocate(allocationBooking($category, ['cell-a', 'cell-b']));

    expect($booking->driver_id)->toBe($near->id)
        ->and($booking->status)->toBe('driver_offered')
        ->and($booking->offer_expires_at)->not->toBeNull();
    Queue::assertPushed(ExpireRideOffer::class);
});

test('a closer driver outside the pickup cells does not beat a driver inside them', function () {
    $category = allocationCategory();
    allocationDriver($category, '9000000004', 25.6001, 85.1001, 'cell-outside');
    $inside = allocationDriver($category, '9000000005', 25.6400, 85.1400, 'cell-a');

    $booking = allocate(allocationBooking($category, ['cell-a']));

    expect($booking->driver_id)->toBe($inside->id);
});

test('falls back to any eligible driver when nobody is in the pickup cells', function () {
    $category = allocationCategory();
    $driver = allocationDriver($category, '9000000006', 25.6010, 85.1010, 'cell-elsewhere');

    $booking = allocate(allocationBooking($category, ['cell-a']));

    expect($booking->driver_id)->toBe($driver->id)
        ->and($booking->status)->toBe('driver_offered');
});

test('falls back to any eligible driver when the booking has no pickup cells', function () {
    $category = allocationCategory();
    $driver = allocationDriver($category, '9000000007', 25.6010, 85.1010, null);

    $booking = allocate(allocationBooking($category, null));

    expect($booking->driver_id)->toBe($driver->id);
});

test('skips a driver who already rejected this booking', function () {
    $category = allocationCategory();
    $rejected = allocationDriver($category, '9000000008', 25.6010, 85.1010, 'cell-a');
    $other = allocationDriver($category, '9000000009', 25.6500, 85.1500, 'cell-a');

    $booking = allocate(allocationBooking($category, ['cell-a'], [$rejected->id]));

    expect($booking->driver_id)->toBe($other->id);
});

test('skips a driver who is already on another active booking', function () {
    $category = allocationCategory();
    $busy = allocationDriver($category, '9000000010', 25.6010, 85.1010, 'cell-a');
    $free = allocationDriver($category, '9000000011', 25.6500, 85.1500, 'cell-a');

    $active = allocationBooking($category, null);
    $active->update(['driver_id' => $busy->id, 'status' => 'driver_assigned']);

    $booking = allocate(allocationBooking($category, ['cell-a']));

    expect($booking->driver_id)->toBe($free->id);
});

test('marks the booking as allocating when no driver is eligible', function () {
    $category = allocationCategory();

    $booking = allocate(allocationBooking($category, ['cell-a']));

    expect($booking->driver_id)->toBeNull()
        ->and($booking->status)->toBe('allocating');
    Queue::assertNotPushed(ExpireRideOffer::class);
});
