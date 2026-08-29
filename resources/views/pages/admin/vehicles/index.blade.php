@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Vehicles" />


    <x-common.component-card title="All Vehicles">
        <x-slot:actions>
            <a href="{{ route('vehicles.create') }}"><x-ui.button size="sm">Add Vehicle</x-ui.button></a>
        </x-slot:actions>

        <x-common.data-table
            :search-action="route('vehicles.index')"
            :bulk-delete-action="route('vehicles.bulk-destroy')"
            search-placeholder="Search by make/model or plate..."
            :search-params="['q', 'category']"
        >
            <x-slot:filters>
                <select name="category" onchange="this.form.submit()"
                    class="dark:bg-dark-900 shadow-theme-xs h-10 appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 pr-9 text-sm text-gray-800 focus:border-brand-300 focus:ring-3 focus:ring-brand-500/10 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90">
                    <option value="">All categories</option>
                    @foreach ($categories as $category)
                        <option value="{{ $category->id }}" @selected((string) $currentCategory === (string) $category->id)>{{ $category->name }}</option>
                    @endforeach
                </select>
            </x-slot:filters>

            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[900px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Vehicle</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Plate</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Category</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Driver</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($vehicles as $vehicle)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$vehicle->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $vehicle->make_model }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $vehicle->plate_number }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $vehicle->category->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $vehicle->driver?->name ?? '— unassigned —' }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <div class="flex items-center gap-1">
                                            <x-common.icon-button icon="edit" title="Edit" :href="route('vehicles.edit', $vehicle)" />
                                            <x-common.row-delete-button :id="$vehicle->id" :label="$vehicle->make_model" />
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="6">No vehicles found.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $vehicles->links() }}</div>
    </x-common.component-card>
@endsection
