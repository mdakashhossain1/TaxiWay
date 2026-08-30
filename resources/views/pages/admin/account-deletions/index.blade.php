@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Account Deletions" />

    <x-common.component-card title="Account Deletion Requests">
        <x-common.data-table
            :search-action="route('account-deletions.index')"
            :bulk-delete-action="route('account-deletions.bulk-destroy')"
            search-placeholder="Search by name, phone, email, or reason..."
        >
            <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
                <div class="max-w-full overflow-x-auto custom-scrollbar">
                    <table class="w-full min-w-[900px]">
                        <thead>
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <th class="px-5 py-3 text-left sm:px-6"><x-common.select-all-checkbox /></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Name</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Phone</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Email</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Reason</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Status</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Requested</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Deleted On</p></th>
                                <th class="px-5 py-3 text-left sm:px-6"></th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($requests as $deletionRequest)
                                <tr class="border-b border-gray-100 dark:border-gray-800">
                                    <td class="px-5 py-4 sm:px-6"><x-common.row-checkbox :id="$deletionRequest->id" /></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $deletionRequest->name ?? '—' }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $deletionRequest->phone }}</span></td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $deletionRequest->email }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <span class="text-gray-500 text-theme-sm dark:text-gray-400 block max-w-xs truncate" title="{{ $deletionRequest->reason }}">
                                            {{ $deletionRequest->reason ?? '—' }}
                                        </span>
                                    </td>
                                    <td class="px-5 py-4 sm:px-6">
                                        @if ($deletionRequest->confirmed_at)
                                            <x-ui.badge color="error">Deleted</x-ui.badge>
                                        @else
                                            <x-ui.badge color="warning">Pending confirmation</x-ui.badge>
                                        @endif
                                    </td>
                                    <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $deletionRequest->created_at->format('d M Y, h:i A') }}</span></td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <span class="text-gray-500 text-theme-sm dark:text-gray-400">
                                            {{ $deletionRequest->confirmed_at?->format('d M Y, h:i A') ?? '—' }}
                                        </span>
                                    </td>
                                    <td class="px-5 py-4 sm:px-6">
                                        <x-common.row-delete-button :id="$deletionRequest->id" :label="$deletionRequest->name ?? $deletionRequest->phone" />
                                    </td>
                                </tr>
                            @empty
                                <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="8">No account deletions yet.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </x-common.data-table>

        <div class="mt-4">{{ $requests->links() }}</div>
    </x-common.component-card>
@endsection
