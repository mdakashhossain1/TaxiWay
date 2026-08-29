<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\DriverSubscriptionPlan;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class DriverSubscriptionPlanController extends Controller
{
    public function index(): View
    {
        $plans = DriverSubscriptionPlan::withCount('subscriptions')->orderBy('price_per_month')->get();

        return view('pages.admin.driver-subscription-plans.index', [
            'title' => 'Subscription Plans',
            'plans' => $plans,
        ]);
    }

    public function create(): View
    {
        return view('pages.admin.driver-subscription-plans.form', [
            'title' => 'Add Plan',
            'plan' => new DriverSubscriptionPlan(['is_active' => true]),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        DriverSubscriptionPlan::create($this->validated($request));

        return redirect()->route('driver-subscription-plans.index')->with('status', 'Plan created.');
    }

    public function edit(DriverSubscriptionPlan $driverSubscriptionPlan): View
    {
        return view('pages.admin.driver-subscription-plans.form', [
            'title' => 'Edit Plan',
            'plan' => $driverSubscriptionPlan,
        ]);
    }

    public function update(Request $request, DriverSubscriptionPlan $driverSubscriptionPlan): RedirectResponse
    {
        $driverSubscriptionPlan->update($this->validated($request));

        return redirect()->route('driver-subscription-plans.index')->with('status', 'Plan updated.');
    }

    public function destroy(DriverSubscriptionPlan $driverSubscriptionPlan): RedirectResponse
    {
        if ($driverSubscriptionPlan->subscriptions()->exists()) {
            return back()->withErrors(['plan' => 'This plan has active subscriptions and cannot be deleted. Mark it inactive instead.']);
        }

        $driverSubscriptionPlan->delete();

        return redirect()->route('driver-subscription-plans.index')->with('status', 'Plan removed.');
    }

    private function validated(Request $request): array
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'price_per_month' => ['required', 'numeric', 'min:0'],
            'rides_included' => ['required', 'integer', 'min:1'],
            'validity_days' => ['required', 'integer', 'min:1'],
            'description' => ['nullable', 'string', 'max:1000'],
            'translations' => ['nullable', 'array'],
            'translations.*.name' => ['nullable', 'string', 'max:255'],
            'translations.*.description' => ['nullable', 'string', 'max:1000'],
        ]);

        $data['is_active'] = $request->boolean('is_active');

        $translations = [];
        foreach (DriverSubscriptionPlan::SUPPORTED_LOCALES as $locale => $label) {
            if ($locale === 'en') {
                continue;
            }

            $name = trim($data['translations'][$locale]['name'] ?? '');
            $description = trim($data['translations'][$locale]['description'] ?? '');

            if ($name !== '' || $description !== '') {
                $translations[$locale] = array_filter([
                    'name' => $name !== '' ? $name : null,
                    'description' => $description !== '' ? $description : null,
                ]);
            }
        }
        $data['translations'] = $translations ?: null;

        return $data;
    }
}
