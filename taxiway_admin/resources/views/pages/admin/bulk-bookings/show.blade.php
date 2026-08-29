@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Bulk Booking #{{ $bulkBooking->id }}" />

    <x-common.back-link :href="route('bookings.index')" label="Back to Bookings" />

    <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div class="lg:col-span-2">
            <x-common.component-card title="Trip Request">
                <dl class="grid grid-cols-2 gap-4 text-sm">
                    <div class="col-span-2"><dt class="text-gray-500 dark:text-gray-400">Route</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->from_location }} → {{ $bulkBooking->to_location }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Travel Date</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->travel_date->format('d M Y') }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Travel Time</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->travel_time }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Passengers</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->passenger_count }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Requested</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->created_at->format('d M Y, h:i A') }}</dd></div>
                    @if ($bulkBooking->notes)
                        <div class="col-span-2"><dt class="text-gray-500 dark:text-gray-400">Notes</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->notes }}</dd></div>
                    @endif
                </dl>
            </x-common.component-card>

            <div class="mt-6">
                <x-common.component-card title="Driver Offers">
                    @forelse ($bulkBooking->offers as $offer)
                        <div class="flex items-center justify-between border-b border-gray-100 py-3 last:border-0 dark:border-gray-800">
                            <div>
                                <p class="font-medium text-gray-800 dark:text-white/90">{{ $offer->driver->name }}</p>
                                <p class="text-sm text-gray-500 dark:text-gray-400">{{ $offer->vehicle->make_model }} ({{ $offer->vehicle->plate_number }})</p>
                            </div>
                            <span class="font-medium text-gray-800 dark:text-white/90">₹{{ $offer->price }}</span>
                        </div>
                    @empty
                        <p class="text-sm text-gray-500 dark:text-gray-400">No driver offers yet.</p>
                    @endforelse
                </x-common.component-card>
            </div>
        </div>

        <div class="space-y-6">
            <x-common.component-card title="Status">
                <x-ui.badge :color="$bulkBooking->status === 'confirmed' ? 'success' : ($bulkBooking->status === 'cancelled' ? 'error' : 'warning')" size="md">{{ $bulkBooking->status }}</x-ui.badge>
            </x-common.component-card>

            <x-common.component-card title="Customer">
                <p class="font-medium text-gray-800 dark:text-white/90">{{ $bulkBooking->customer->name }}</p>
                <p class="text-sm text-gray-500 dark:text-gray-400">{{ $bulkBooking->contact_name }} · {{ $bulkBooking->contact_phone }}</p>
                <a href="{{ route('customers.show', $bulkBooking->customer) }}" class="mt-2 inline-block text-brand-500 hover:text-brand-600 text-theme-sm font-medium">View customer</a>
            </x-common.component-card>
        </div>
    </div>
@endsection
