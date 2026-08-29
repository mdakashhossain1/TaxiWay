@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Bookings" />


    <x-common.component-card title="All Bookings">
        <div class="flex flex-wrap gap-2 -mt-2 mb-4">
            @foreach (['' => 'All', 'requested' => 'Requested', 'driver_assigned' => 'Assigned', 'completed' => 'Completed', 'cancelled' => 'Cancelled'] as $value => $label)
                <a href="{{ route('bookings.index', array_filter(['status' => $value, 'q' => request('q')])) }}"
                   class="rounded-full px-3 py-1 text-xs font-medium {{ $currentStatus === $value ? 'bg-brand-500 text-white' : 'bg-gray-100 text-gray-600 dark:bg-white/5 dark:text-gray-300' }}">
                    {{ $label }}
                </a>
            @endforeach
        </div>

        <x-common.data-table
            :search-action="route('bookings.index')"
            :bulk-delete-action="route('bookings.bulk-destroy')"
            search-placeholder="Search by address or customer name..."
            :search-params="['q', 'status']"
        >
            @if ($currentStatus)
                <x-slot:filters>
                    <input type="hidden" name="status" value="{{ $currentStatus }}" />
                </x-slot:filters>
            @endif

            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[900px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Route</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Customer</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Driver</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Fare</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Status</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($bookings as $booking)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$booking->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $booking->pickup_address }} → {{ $booking->destination_address }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $booking->customer->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $booking->driver?->name ?? '—' }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">₹{{ $booking->total_fare }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <x-ui.badge :color="$booking->status === 'completed' ? 'success' : ($booking->status === 'cancelled' ? 'error' : 'warning')">{{ $booking->status }}</x-ui.badge>
                                    </td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <div class="flex items-center gap-1">
                                            <x-common.icon-button icon="view" title="View" :href="route('bookings.show', $booking)" />
                                            <x-common.row-delete-button :id="$booking->id" label="booking #{{ $booking->id }}" />
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="7">No bookings found.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $bookings->links() }}</div>
    </x-common.component-card>
@endsection
