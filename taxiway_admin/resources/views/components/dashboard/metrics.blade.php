@php
    $cards = [
        ['label' => 'Customers', 'value' => number_format($customersCount)],
        ['label' => 'Drivers', 'value' => number_format($driversCount)],
        ['label' => 'Bookings', 'value' => number_format($bookingsCount)],
        ['label' => 'Revenue (Completed)', 'value' => '₹' . number_format($totalRevenue, 2)],
    ];
@endphp

<div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 md:gap-6">
    @foreach ($cards as $card)
        <div class="rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03] md:p-6">
            <span class="text-sm text-gray-500 dark:text-gray-400">{{ $card['label'] }}</span>
            <h4 class="mt-2 font-bold text-gray-800 text-title-sm dark:text-white/90">{{ $card['value'] }}</h4>
        </div>
    @endforeach
</div>
