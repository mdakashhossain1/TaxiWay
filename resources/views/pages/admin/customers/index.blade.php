@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Customers" />


    <x-common.component-card title="All Customers">
        <x-common.data-table
            :search-action="route('customers.index')"
            :bulk-delete-action="route('customers.bulk-destroy')"
            search-placeholder="Search by name, phone, or email..."
        >
            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[800px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Name</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Phone</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Bookings</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Joined</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($customers as $customer)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$customer->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $customer->name }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $customer->phone }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $customer->bookings_count }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $customer->created_at->format('d M Y') }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <div class="flex items-center gap-1">
                                            <x-common.icon-button icon="view" title="View" :href="route('customers.show', $customer)" />
                                            <x-common.icon-button icon="edit" title="Edit" :href="route('customers.edit', $customer)" />
                                            <x-common.row-delete-button :id="$customer->id" :label="$customer->name" />
                                        </div>
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="6">No customers found.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $customers->links() }}</div>
    </x-common.component-card>
@endsection
