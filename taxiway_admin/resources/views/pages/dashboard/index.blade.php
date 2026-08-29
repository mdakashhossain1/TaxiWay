@extends('layouts.app')

@section('content')
    <div class="space-y-6">
        <x-dashboard.metrics
            :customers-count="$customersCount"
            :drivers-count="$driversCount"
            :bookings-count="$bookingsCount"
            :total-revenue="$totalRevenue"
        />

        <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
            <x-common.component-card title="Bookings (Last 30 Days)">
                <div id="chartBookingsTrend"></div>
            </x-common.component-card>
            <x-common.component-card title="Revenue (Last 30 Days)">
                <div id="chartRevenueTrend"></div>
            </x-common.component-card>
        </div>

        <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
            <x-common.component-card title="Booking Status Breakdown">
                <div id="chartStatusBreakdown"></div>
            </x-common.component-card>
            <x-common.component-card title="Bookings by Vehicle Category">
                <div id="chartCategoryBreakdown"></div>
            </x-common.component-card>
        </div>

        <x-common.component-card title="Recent Bookings">
            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[800px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Route</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Customer</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Fare</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Status</p></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($recentBookings as $booking)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><a href="{{ route('bookings.show', $booking) }}" class="text-gray-500 hover:text-brand-600 text-theme-sm dark:text-gray-400">{{ $booking->pickup_address }} → {{ $booking->destination_address }}</a></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $booking->customer->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">₹{{ $booking->total_fare }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <x-ui.badge :color="$booking->status === 'completed' ? 'success' : ($booking->status === 'cancelled' ? 'error' : 'warning')">{{ $booking->status }}</x-ui.badge>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="4">No bookings yet.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.component-card>
    </div>

    @push('scripts')
        <script>
            window.dashboardChartsData = {
                chartLabels: @json($chartLabels),
                bookingsTrend: @json($bookingsTrend),
                revenueTrend: @json($revenueTrend),
                statusLabels: @json($statusLabels),
                statusCounts: @json($statusCounts),
                categoryLabels: @json($categoryLabels),
                categoryCounts: @json($categoryCounts),
            };
        </script>
    @endpush
@endsection
