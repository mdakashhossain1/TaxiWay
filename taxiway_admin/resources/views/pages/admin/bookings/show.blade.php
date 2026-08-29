@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Booking #{{ $booking->id }}" />

    <x-common.back-link :href="route('bookings.index')" label="Back to Bookings" />

    <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div class="lg:col-span-2">
            <x-common.component-card title="Trip">
                <dl class="grid grid-cols-2 gap-4 text-sm">
                    <div class="col-span-2"><dt class="text-gray-500 dark:text-gray-400">Route</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $booking->pickup_address }} → {{ $booking->destination_address }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Distance</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $booking->distance_km }} km</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Category</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $booking->category->name }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Fare</dt><dd class="font-medium text-gray-800 dark:text-white/90">₹{{ $booking->total_fare }} ({{ $booking->payment_method }}, {{ $booking->payment_status }})</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Booked</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $booking->created_at->format('d M Y, h:i A') }}</dd></div>
                </dl>

                @if ($booking->review)
                    <div class="mt-6 border-t border-gray-100 pt-4 dark:border-gray-800">
                        <h4 class="mb-2 font-medium text-gray-800 dark:text-white/90">Review — {{ $booking->review->rating }}★</h4>
                        <p class="text-sm text-gray-500 dark:text-gray-400">{{ $booking->review->comment ?? 'No comment left.' }}</p>
                    </div>
                @endif
            </x-common.component-card>
        </div>

        <div class="space-y-6">
            <x-common.component-card title="Status">
                <x-ui.badge :color="$booking->status === 'completed' ? 'success' : ($booking->status === 'cancelled' ? 'error' : 'warning')" size="md">{{ $booking->status }}</x-ui.badge>

                <form method="POST" action="{{ route('bookings.update-status', $booking) }}" class="mt-4 flex items-end gap-2">
                    @csrf
                    @method('PATCH')
                    <div class="flex-1">
                        <x-form.select name="status">
                            @foreach ($statuses as $status)
                                <option value="{{ $status }}" @selected($booking->status === $status)>{{ ucwords(str_replace('_', ' ', $status)) }}</option>
                            @endforeach
                        </x-form.select>
                    </div>
                    <x-ui.button size="sm" type="submit">Update</x-ui.button>
                </form>
            </x-common.component-card>

            <x-common.component-card title="Customer">
                <p class="font-medium text-gray-800 dark:text-white/90">{{ $booking->customer->name }}</p>
                <p class="text-sm text-gray-500 dark:text-gray-400">{{ $booking->customer->phone }}</p>
                <a href="{{ route('customers.show', $booking->customer) }}" class="mt-2 inline-block text-brand-500 hover:text-brand-600 text-theme-sm font-medium">View customer</a>
            </x-common.component-card>

            @if ($booking->driver)
                <x-common.component-card title="Driver">
                    <p class="font-medium text-gray-800 dark:text-white/90">{{ $booking->driver->name }}</p>
                    <p class="text-sm text-gray-500 dark:text-gray-400">{{ $booking->vehicle?->make_model }} ({{ $booking->vehicle?->plate_number }})</p>
                    <a href="{{ route('drivers.show', $booking->driver) }}" class="mt-2 inline-block text-brand-500 hover:text-brand-600 text-theme-sm font-medium">View driver</a>
                </x-common.component-card>
            @endif

            <form method="POST" action="{{ route('bookings.destroy', $booking) }}" id="delete-booking-form"
                class="rounded-2xl border border-gray-200 bg-white p-4 text-center dark:border-gray-800 dark:bg-white/[0.03]">
                @csrf
                @method('DELETE')
                <button type="button"
                    @click="$store.confirm.ask('Delete booking #{{ $booking->id }}?', 'This cannot be undone.', () => document.getElementById('delete-booking-form').requestSubmit())"
                    class="text-error-500 hover:text-error-600 text-theme-sm font-medium">Delete Booking</button>
            </form>
        </div>
    </div>
@endsection
