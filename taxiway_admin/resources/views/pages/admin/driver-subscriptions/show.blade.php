@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$subscription->driver->name . '\'s Subscription'" />

    <x-common.back-link :href="route('driver-subscriptions.index')" label="Back to Subscriptions" />

    <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div class="lg:col-span-2">
            <x-common.component-card title="Payment History">
                @forelse ($subscription->payments as $payment)
                    <div class="flex items-center justify-between border-b border-gray-100 py-3 last:border-0 dark:border-gray-800">
                        <div>
                            <p class="font-medium text-gray-800 dark:text-white/90">₹{{ $payment->amount }} · {{ $payment->payment_method }}</p>
                            <p class="text-sm text-gray-500 dark:text-gray-400">Paid {{ $payment->paid_on->format('d M Y') }} · next renewal {{ $payment->next_renewal->format('d M Y') }}</p>
                        </div>
                    </div>
                @empty
                    <p class="text-sm text-gray-500 dark:text-gray-400">No payments recorded yet.</p>
                @endforelse
            </x-common.component-card>
        </div>

        <div class="space-y-6">
            <x-common.component-card title="Plan">
                <p class="font-medium text-gray-800 dark:text-white/90">{{ $subscription->plan->name }} — ₹{{ $subscription->plan->price_per_month }}/mo</p>
                <p class="mt-2 text-lg font-semibold text-gray-800 dark:text-white/90">{{ $subscription->rides_used }} / {{ $subscription->plan->rides_included }} rides used</p>
                <p class="text-sm text-gray-500 dark:text-gray-400">Renews {{ $subscription->renewal_date->format('d M Y') }}</p>
                <x-ui.badge class="mt-3" :color="$subscription->status === 'active' ? 'success' : 'warning'">{{ $subscription->status }}</x-ui.badge>

                <a href="{{ route('driver-subscriptions.edit', $subscription) }}" class="mt-4 block text-center">
                    <x-ui.button size="sm" variant="outline" className="w-full">Edit</x-ui.button>
                </a>
            </x-common.component-card>

            <x-common.component-card title="Driver">
                <p class="font-medium text-gray-800 dark:text-white/90">{{ $subscription->driver->name }}</p>
                <p class="text-sm text-gray-500 dark:text-gray-400">{{ $subscription->driver->phone }}</p>
                <a href="{{ route('drivers.show', $subscription->driver) }}" class="mt-2 inline-block text-brand-500 hover:text-brand-600 text-theme-sm font-medium">View driver</a>
            </x-common.component-card>

            <form method="POST" action="{{ route('driver-subscriptions.destroy', $subscription) }}" id="delete-subscription-form"
                class="rounded-2xl border border-gray-200 bg-white p-4 text-center dark:border-gray-800 dark:bg-white/[0.03]">
                @csrf
                @method('DELETE')
                <button type="button"
                    @click="$store.confirm.ask('Delete this subscription?', 'This cannot be undone.', () => document.getElementById('delete-subscription-form').requestSubmit())"
                    class="text-error-500 hover:text-error-600 text-theme-sm font-medium">Delete Subscription</button>
            </form>
        </div>
    </div>
@endsection
