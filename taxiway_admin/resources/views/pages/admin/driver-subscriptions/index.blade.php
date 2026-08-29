@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Driver Subscriptions" />

    <x-common.component-card title="All Subscriptions">
        <x-slot:actions>
            <a href="{{ route('driver-subscriptions.create') }}"><x-ui.button size="sm">Add Subscription</x-ui.button></a>
        </x-slot:actions>

        <x-common.data-table
            :search-action="route('driver-subscriptions.index')"
            :bulk-delete-action="route('driver-subscriptions.bulk-destroy')"
            search-placeholder="Search by driver name..."
            :search-params="['q', 'status']"
        >
            <x-slot:filters>
                <select name="status" onchange="this.form.submit()"
                    class="dark:bg-dark-900 shadow-theme-xs h-10 appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 pr-9 text-sm text-gray-800 focus:border-brand-300 focus:ring-3 focus:ring-brand-500/10 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90">
                    <option value="">All statuses</option>
                    @foreach ($statuses as $status)
                        <option value="{{ $status }}" @selected($currentStatus === $status)>{{ ucwords(str_replace('_', ' ', $status)) }}</option>
                    @endforeach
                </select>
            </x-slot:filters>

            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[900px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Driver</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Plan</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Usage</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Renewal</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Status</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($subscriptions as $subscription)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$subscription->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $subscription->driver->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $subscription->plan->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $subscription->rides_used }} / {{ $subscription->plan->rides_included }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $subscription->renewal_date->format('d M Y') }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <x-ui.badge :color="$subscription->status === 'active' ? 'success' : ($subscription->status === 'suspended' || $subscription->status === 'expired' ? 'error' : 'warning')">{{ $subscription->status }}</x-ui.badge>
                                    </td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <div class="flex items-center gap-1">
                                            <x-common.icon-button icon="view" title="View" :href="route('driver-subscriptions.show', $subscription)" />
                                            <x-common.icon-button icon="edit" title="Edit" :href="route('driver-subscriptions.edit', $subscription)" />
                                            <x-common.row-delete-button :id="$subscription->id" :label="$subscription->driver->name . '\'s subscription'" />
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="7">No subscriptions found.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $subscriptions->links() }}</div>
    </x-common.component-card>
@endsection
