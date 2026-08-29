<?php

namespace App\Http\Controllers\Api\Driver;

use App\Http\Controllers\Controller;
use App\Models\Driver;
use App\Models\DriverSubscriptionPlan;
use App\Models\SubscriptionPayment;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class SubscriptionController extends Controller
{
    private function driver(Request $request): Driver
    {
        abort_unless($request->user() instanceof Driver, 403);

        return $request->user();
    }

    public function show(Request $request): JsonResponse
    {
        $driver = $this->driver($request);
        $subscription = $driver->subscription()->with(['plan', 'payments' => fn ($q) => $q->latest('paid_on')])->first();

        abort_if($subscription === null, 404, 'No active subscription for this driver.');

        $subscription->plan->localizeFor(DriverSubscriptionPlan::resolveLocale($request->header('Accept-Language')));

        $completedBookings = $driver->bookings()->where('status', 'completed');

        $summary = [
            'this_month_collected' => (clone $completedBookings)->whereMonth('updated_at', now()->month)->whereYear('updated_at', now()->year)->sum('total_fare'),
            'completed_rides' => (clone $completedBookings)->count(),
            'today_collected' => (clone $completedBookings)->whereDate('updated_at', today())->sum('total_fare'),
            'pending_payment' => $driver->bookings()->where('payment_status', 'pending')->sum('total_fare'),
        ];

        return response()->json([
            'data' => [
                'subscription' => $subscription,
                'summary' => $summary,
                'latest_payment' => $subscription->payments->first(),
            ],
        ]);
    }

    /**
     * Resets the usage counter, advances the renewal date by one billing
     * cycle, and records the payment — mirrors taxiwaydriver's mock
     * SubscriptionController.renewSubscription() behaviour exactly.
     */
    public function renew(Request $request): JsonResponse
    {
        $driver = $this->driver($request);
        $subscription = $driver->subscription()->with('plan')->first();
        abort_if($subscription === null, 404, 'No active subscription for this driver.');

        DB::transaction(function () use ($subscription) {
            $nextRenewal = Carbon::parse($subscription->renewal_date)->addDays($subscription->plan->validity_days);

            SubscriptionPayment::create([
                'driver_subscription_id' => $subscription->id,
                'amount' => $subscription->plan->price_per_month,
                'paid_on' => today(),
                'payment_method' => 'UPI',
                'next_renewal' => $nextRenewal,
            ]);

            $subscription->update([
                'rides_used' => 0,
                'renewal_date' => $nextRenewal,
                'status' => 'active',
            ]);
        });

        $fresh = $subscription->fresh(['plan', 'payments']);
        $fresh->plan->localizeFor(DriverSubscriptionPlan::resolveLocale($request->header('Accept-Language')));

        return response()->json(['data' => $fresh]);
    }
}
