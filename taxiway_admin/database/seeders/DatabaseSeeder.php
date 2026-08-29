<?php

namespace Database\Seeders;

use App\Models\ApiClient;
use App\Models\Customer;
use App\Models\Driver;
use App\Models\DriverSubscription;
use App\Models\DriverSubscriptionPlan;
use App\Models\Vehicle;
use App\Models\VehicleCategory;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database. No Faker dependency, so this is safe
     * to run in production under `composer install --no-dev`. Use
     * `php artisan admin:create` for a real admin login instead of a seeded
     * default account.
     */
    public function run(): void
    {
        $this->seedApiClients();
        $this->seedTaxiwayDemoData();
    }

    /**
     * Issues one HMAC client secret per Flutter app. The plaintext secret is
     * only ever available here, at issuance time — the database stores it
     * AES-256 encrypted (ApiClient::client_secret has the `encrypted` cast).
     */
    private function seedApiClients(): void
    {
        foreach (['taxiway', 'taxiwaydriver'] as $clientKey) {
            if (ApiClient::where('client_key', $clientKey)->exists()) {
                continue;
            }

            $secret = Str::random(64);

            ApiClient::create([
                'name' => $clientKey,
                'client_key' => $clientKey,
                'client_secret' => $secret,
                'is_active' => true,
            ]);

            $this->command?->info("API client [{$clientKey}] secret (save this, shown once): {$secret}");
        }
    }

    private function seedTaxiwayDemoData(): void
    {
        $sedan = VehicleCategory::firstOrCreate(
            ['name' => 'Sedan'],
            ['seats' => 4, 'ac' => true, 'base_fare' => 120, 'per_km_rate' => 18, 'per_min_rate' => 1]
        );
        VehicleCategory::firstOrCreate(
            ['name' => 'Hatchback'],
            ['seats' => 4, 'ac' => true, 'base_fare' => 100, 'per_km_rate' => 15, 'per_min_rate' => 1]
        );
        VehicleCategory::firstOrCreate(
            ['name' => 'SUV'],
            ['seats' => 7, 'ac' => true, 'base_fare' => 180, 'per_km_rate' => 22, 'per_min_rate' => 0]
        );
        VehicleCategory::firstOrCreate(
            ['name' => 'Traveller'],
            ['seats' => 12, 'ac' => true, 'base_fare' => 250, 'per_km_rate' => 25, 'per_min_rate' => 2]
        );

        Customer::firstOrCreate(
            ['phone' => '9876543210'],
            ['name' => 'Akash Verma', 'email' => 'akashhossain0556@gmail.com']
        );

        $driver = Driver::firstOrCreate(
            ['phone' => '9876500000'],
            [
                'name' => 'Amit Kumar',
                'rating' => 4.8,
                'total_trips' => 230,
                'completion_rate' => 98,
                'years_experience' => 3,
                'identity_verified' => true,
                'licence_verified' => true,
                'background_checked' => true,
                'languages' => ['Hindi', 'English'],
                'operating_area' => 'Patna',
                'member_since' => '2023-01-01',
                'verification_status' => 'verified',
            ]
        );

        $vehicle = Vehicle::firstOrCreate(
            ['plate_number' => 'BR01PA1234'],
            [
                'driver_id' => $driver->id,
                'vehicle_category_id' => $sedan->id,
                'make_model' => 'White Swift Dzire',
                'color' => 'White',
                'fuel_type' => 'petrol',
                'non_smoking' => true,
                'gps_enabled' => true,
            ]
        );

        $plan = DriverSubscriptionPlan::firstOrCreate(
            ['name' => 'Standard'],
            ['price_per_month' => 500, 'rides_included' => 20, 'validity_days' => 30, 'is_active' => true]
        );

        DriverSubscription::firstOrCreate(
            ['driver_id' => $driver->id],
            [
                'driver_subscription_plan_id' => $plan->id,
                'rides_used' => 12,
                'start_date' => '2026-08-18',
                'renewal_date' => '2026-09-18',
                'status' => 'active',
            ]
        );
    }
}
