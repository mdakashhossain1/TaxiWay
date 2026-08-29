@props([
    'events' => [],
    'currentMonth' => null,
    'monthLabel' => now()->format('F Y'),
    'prevMonth' => null,
    'nextMonth' => null,
    'bookingsTotal' => 0,
    'bookingsCompleted' => 0,
    'bulkTotal' => 0,
    'bulkConfirmed' => 0,
])

@php
    $currentMonth ??= now()->format('Y-m');
    $prevMonth ??= now()->subMonth()->format('Y-m');
    $nextMonth ??= now()->addMonth()->format('Y-m');
@endphp

<div class="space-y-6">
    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div class="rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03]">
            <span class="text-sm text-gray-500 dark:text-gray-400">Bookings in {{ $monthLabel }}</span>
            <h4 class="mt-2 font-bold text-gray-800 text-title-sm dark:text-white/90">
                {{ $bookingsCompleted }} / {{ $bookingsTotal }} completed
            </h4>
        </div>
        <div class="rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03]">
            <span class="text-sm text-gray-500 dark:text-gray-400">Bulk requests in {{ $monthLabel }}</span>
            <h4 class="mt-2 font-bold text-gray-800 text-title-sm dark:text-white/90">
                {{ $bulkConfirmed }} / {{ $bulkTotal }} confirmed
            </h4>
        </div>
    </div>

    <div class="rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]">
        <div class="flex flex-wrap items-center gap-4 border-b border-gray-100 px-6 py-3 dark:border-gray-800">
            <span class="flex items-center gap-1.5 text-theme-xs text-gray-500 dark:text-gray-400"><span class="h-2 w-2 rounded-full bg-brand-500"></span> Requested / submitted</span>
            <span class="flex items-center gap-1.5 text-theme-xs text-gray-500 dark:text-gray-400"><span class="h-2 w-2 rounded-full bg-orange-500"></span> In progress / offer ready</span>
            <span class="flex items-center gap-1.5 text-theme-xs text-gray-500 dark:text-gray-400"><span class="h-2 w-2 rounded-full bg-success-500"></span> Completed / confirmed</span>
            <span class="flex items-center gap-1.5 text-theme-xs text-gray-500 dark:text-gray-400"><span class="h-2 w-2 rounded-full bg-error-500"></span> Cancelled / failed</span>
        </div>
        <div class="custom-calendar">
            <div id="calendar" class="min-h-screen"></div>
        </div>
    </div>
</div>

@push('scripts')
    <script>
        window.calendarData = {
            events: @json($events),
            currentMonth: @json($currentMonth),
            prevMonthUrl: @json(route('calendar', ['month' => $prevMonth])),
            nextMonthUrl: @json(route('calendar', ['month' => $nextMonth])),
        };
    </script>
@endpush
