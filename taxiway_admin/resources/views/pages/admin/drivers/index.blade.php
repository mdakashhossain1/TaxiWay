@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Drivers" />


    <x-common.component-card title="All Drivers">
        <x-slot:actions>
            <a href="{{ route('drivers.create') }}"><x-ui.button size="sm">Add Driver</x-ui.button></a>
        </x-slot:actions>

        <x-common.data-table
            :search-action="route('drivers.index')"
            :bulk-delete-action="route('drivers.bulk-destroy')"
            search-placeholder="Search by name or phone..."
            :search-params="['q', 'status']"
        >
            <x-slot:filters>
                <select name="status" onchange="this.form.submit()"
                    class="dark:bg-dark-900 shadow-theme-xs h-10 appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 pr-9 text-sm text-gray-800 focus:border-brand-300 focus:ring-3 focus:ring-brand-500/10 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90">
                    <option value="">All statuses</option>
                    @foreach (['verified' => 'Verified', 'pending' => 'Pending', 'suspended' => 'Suspended'] as $value => $label)
                        <option value="{{ $value }}" @selected($currentStatus === $value)>{{ $label }}</option>
                    @endforeach
                </select>
            </x-slot:filters>

            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[900px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Name</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Phone</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Vehicles</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Rating</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Status</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($drivers as $driver)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$driver->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $driver->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $driver->phone }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $driver->vehicles_count }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $driver->rating }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <x-ui.badge :color="$driver->verification_status === 'verified' ? 'success' : ($driver->verification_status === 'suspended' ? 'error' : 'warning')">
                                            {{ $driver->verification_status }}
                                        </x-ui.badge>
                                    </td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <div class="flex items-center gap-1">
                                            <x-common.icon-button icon="view" title="View" :href="route('drivers.show', $driver)" />
                                            <x-common.icon-button icon="edit" title="Edit" :href="route('drivers.edit', $driver)" />
                                            <x-common.row-delete-button :id="$driver->id" :label="$driver->name" />
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="7">No drivers found.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $drivers->links() }}</div>
    </x-common.component-card>
@endsection
