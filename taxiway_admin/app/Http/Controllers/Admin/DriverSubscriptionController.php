<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Driver;
use App\Models\DriverSubscription;
use App\Models\DriverSubscriptionPlan;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\View\View;

class DriverSubscriptionController extends Controller
{
    private const STATUSES = [
        'active', 'expiring_soon', 'expired', 'quota_exhausted', 'payment_pending', 'suspended',
    ];

    public function index(Request $request): View
    {
        $query = DriverSubscription::with(['driver', 'plan'])->latest();

        if ($q = $request->query('q')) {
            $query->whereHas('driver', fn ($d) => $d->where('name', 'like', "%{$q}%"));
        }

        if ($status = $request->query('status')) {
            $query->where('status', $status);
        }

        $subscriptions = $query->paginate(15)->withQueryString();

        return view('pages.admin.driver-subscriptions.index', [
            'title' => 'Driver Subscriptions',
            'subscriptions' => $subscriptions,
            'currentStatus' => $status ?? '',
            'statuses' => self::STATUSES,
        ]);
    }

    public function create(): View
    {
        return view('pages.admin.driver-subscriptions.create', [
            'title' => 'Add Subscription',
            'drivers' => Driver::whereDoesntHave('subscription')->orderBy('name')->get(),
            'plans' => DriverSubscriptionPlan::where('is_active', true)->orderBy('price_per_month')->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'driver_id' => ['required', 'exists:drivers,id', 'unique:driver_subscriptions,driver_id'],
            'driver_subscription_plan_id' => ['required', 'exists:driver_subscription_plans,id'],
        ]);

        $plan = DriverSubscriptionPlan::findOrFail($data['driver_subscription_plan_id']);
        $startDate = Carbon::today();

        $subscription = DriverSubscription::create([
            ...$data,
            'rides_used' => 0,
            'start_date' => $startDate,
            'renewal_date' => $startDate->copy()->addDays($plan->validity_days),
            'status' => 'active',
        ]);

        return redirect()->route('driver-subscriptions.show', $subscription)->with('status', 'Subscription created.');
    }

    public function show(DriverSubscription $driverSubscription): View
    {
        $driverSubscription->load(['driver', 'plan', 'payments' => fn ($q) => $q->latest('paid_on')]);

        return view('pages.admin.driver-subscriptions.show', [
            'title' => "{$driverSubscription->driver->name}'s Subscription",
            'subscription' => $driverSubscription,
        ]);
    }

    public function edit(DriverSubscription $driverSubscription): View
    {
        $driverSubscription->load('driver');

        return view('pages.admin.driver-subscriptions.edit', [
            'title' => 'Edit Subscription',
            'subscription' => $driverSubscription,
            'plans' => DriverSubscriptionPlan::where('is_active', true)
                ->orWhere('id', $driverSubscription->driver_subscription_plan_id)
                ->orderBy('price_per_month')->get(),
            'statuses' => self::STATUSES,
        ]);
    }

    public function update(Request $request, DriverSubscription $driverSubscription): RedirectResponse
    {
        $data = $request->validate([
            'driver_subscription_plan_id' => ['required', 'exists:driver_subscription_plans,id'],
            'status' => ['required', 'in:'.implode(',', self::STATUSES)],
            'rides_used' => ['required', 'integer', 'min:0'],
            'renewal_date' => ['required', 'date'],
        ]);

        $driverSubscription->update($data);

        return redirect()->route('driver-subscriptions.show', $driverSubscription)->with('status', 'Subscription updated.');
    }

    public function destroy(DriverSubscription $driverSubscription): RedirectResponse
    {
        $driverSubscription->delete();

        return redirect()->route('driver-subscriptions.index')->with('status', 'Subscription removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = DriverSubscription::whereIn('id', $ids)->delete();

        return redirect()->route('driver-subscriptions.index')->with('status', "{$count} subscription(s) removed.");
    }
}
