@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Add Subscription" />

    <x-common.back-link :href="route('driver-subscriptions.index')" label="Back to Subscriptions" />

    <x-common.component-card title="New Subscription">
        @if ($drivers->isEmpty())
            <p class="text-theme-sm text-gray-500 dark:text-gray-400">Every driver already has a subscription — there's no one left to assign one to.</p>
        @elseif ($plans->isEmpty())
            <p class="text-theme-sm text-gray-500 dark:text-gray-400">
                There are no active subscription plans yet.
                <a href="{{ route('driver-subscription-plans.create') }}" class="font-medium text-brand-500 hover:text-brand-600">Create one first</a>.
            </p>
        @else
            <form method="POST" action="{{ route('driver-subscriptions.store') }}" class="space-y-5">
                @csrf

                <x-form.select name="driver_id" label="Driver">
                    <option value="">Select driver</option>
                    @foreach ($drivers as $driver)
                        <option value="{{ $driver->id }}" @selected(old('driver_id') == $driver->id)>{{ $driver->name }} — {{ $driver->phone }}</option>
                    @endforeach
                </x-form.select>

                <x-form.select name="driver_subscription_plan_id" label="Plan">
                    <option value="">Select plan</option>
                    @foreach ($plans as $plan)
                        <option value="{{ $plan->id }}" @selected(old('driver_subscription_plan_id') == $plan->id)>{{ $plan->name }} — ₹{{ $plan->price_per_month }}, {{ $plan->rides_included }} rides, {{ $plan->validity_days }} days</option>
                    @endforeach
                </x-form.select>

                <p class="text-sm text-gray-500 dark:text-gray-400">Starts today with 0 rides used. Renewal date is set automatically from the plan's validity period.</p>

                <x-ui.button type="submit">Create Subscription</x-ui.button>
            </form>
        @endif
    </x-common.component-card>
@endsection
