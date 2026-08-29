@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$customer->name" />

    <x-common.back-link :href="route('customers.index')" label="Back to Customers" />

    <x-common.component-card title="Customer Details">
        <div class="flex justify-end -mt-2 mb-4">
            <a href="{{ route('customers.edit', $customer) }}"><x-ui.button size="sm" variant="outline">Edit</x-ui.button></a>
        </div>

        <dl class="grid grid-cols-2 gap-4 text-sm mb-6">
            <div><dt class="text-gray-500 dark:text-gray-400">Phone</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $customer->phone }}</dd></div>
            <div><dt class="text-gray-500 dark:text-gray-400">Email</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $customer->email ?? '—' }}</dd></div>
            <div><dt class="text-gray-500 dark:text-gray-400">Joined</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $customer->created_at->format('d M Y') }}</dd></div>
        </dl>

        <h4 class="mb-3 font-medium text-gray-800 dark:text-white/90">Recent Bookings</h4>
        @forelse ($customer->bookings as $booking)
            <div class="flex items-center justify-between border-b border-gray-100 py-3 last:border-0 dark:border-gray-800">
                <div>
                    <p class="font-medium text-gray-800 dark:text-white/90">{{ $booking->pickup_address }} → {{ $booking->destination_address }}</p>
                    <p class="text-sm text-gray-500 dark:text-gray-400">₹{{ $booking->total_fare }} · {{ $booking->driver?->name ?? 'Unassigned' }} · {{ $booking->created_at->format('d M, h:i A') }}</p>
                </div>
                <x-ui.badge :color="$booking->status === 'completed' ? 'success' : ($booking->status === 'cancelled' ? 'error' : 'warning')">{{ $booking->status }}</x-ui.badge>
            </div>
        @empty
            <p class="text-sm text-gray-500 dark:text-gray-400">No bookings yet.</p>
        @endforelse
    </x-common.component-card>
@endsection
