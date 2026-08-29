@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Vehicle Categories & Pricing" />


    <x-common.component-card title="Categories">
        <x-slot:actions>
            <a href="{{ route('vehicle-categories.create') }}"><x-ui.button size="sm">Add Category</x-ui.button></a>
        </x-slot:actions>

        <x-common.data-table
            :search-action="route('vehicle-categories.index')"
            :bulk-delete-action="route('vehicle-categories.bulk-destroy')"
            search-placeholder="Search by name..."
        >
            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[900px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Name</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Seats</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Base Fare</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Per KM</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Per Min</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Vehicles</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($categories as $category)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$category->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $category->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $category->seats }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">₹{{ $category->base_fare }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">₹{{ $category->per_km_rate }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">₹{{ $category->per_min_rate }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $category->vehicles_count }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <div class="flex items-center gap-1">
                                            <x-common.icon-button icon="edit" title="Edit" :href="route('vehicle-categories.edit', $category)" />
                                            <x-common.row-delete-button :id="$category->id" :label="$category->name" />
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="8">No categories found.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $categories->links() }}</div>
    </x-common.component-card>
@endsection
