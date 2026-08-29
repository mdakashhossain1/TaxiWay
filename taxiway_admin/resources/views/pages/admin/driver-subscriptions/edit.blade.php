@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Edit Subscription" />

    <x-common.back-link :href="route('driver-subscriptions.index')" label="Back to Subscriptions" />

    <x-common.component-card title="Edit {{ $subscription->driver->name }}'s Subscription">
        <form method="POST" action="{{ route('driver-subscriptions.update', $subscription) }}" class="space-y-5">
            @csrf
            @method('PUT')

            <x-form.select name="driver_subscription_plan_id" label="Plan">
                @foreach ($plans as $plan)
                    <option value="{{ $plan->id }}" @selected(old('driver_subscription_plan_id', $subscription->driver_subscription_plan_id) == $plan->id)>{{ $plan->name }} — ₹{{ $plan->price_per_month }}, {{ $plan->rides_included }} rides, {{ $plan->validity_days }} days</option>
                @endforeach
            </x-form.select>

            <x-form.select name="status" label="Status">
                @foreach ($statuses as $status)
                    <option value="{{ $status }}" @selected(old('status', $subscription->status) === $status)>{{ ucwords(str_replace('_', ' ', $status)) }}</option>
                @endforeach
            </x-form.select>

            <x-form.input type="number" name="rides_used" label="Rides Used" min="0" value="{{ old('rides_used', $subscription->rides_used) }}" required />

            <x-form.input type="date" name="renewal_date" label="Renewal Date" value="{{ old('renewal_date', $subscription->renewal_date->format('Y-m-d')) }}" required />

            <x-ui.button type="submit">Save Changes</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
