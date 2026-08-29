@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Subscription Plans" />

    <x-common.component-card title="All Plans">
        <x-slot:actions>
            <a href="{{ route('driver-subscription-plans.create') }}"><x-ui.button size="sm">Add Plan</x-ui.button></a>
        </x-slot:actions>

        @if (session('errors') && $errors->has('plan'))
            <div class="mb-4"><x-ui.alert variant="error" :message="$errors->first('plan')" /></div>
        @endif

        <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
            <div class="max-w-full overflow-x-auto custom-scrollbar">
                <table class="w-full min-w-[800px]">
                    <thead>
                        <tr class="border-b border-gray-100 dark:border-gray-800">
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Name</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Price</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Ride Quota</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Validity</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Subscribers</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Status</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"></th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse ($plans as $plan)
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <td class="px-5 py-4 sm:px-6">
                                    <span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $plan->name }}</span>
                                    @if ($plan->description)
                                        <p class="text-theme-xs text-gray-500 dark:text-gray-400">{{ $plan->description }}</p>
                                    @endif
                                    <div class="mt-1 flex gap-1">
                                        @foreach (\App\Models\DriverSubscriptionPlan::SUPPORTED_LOCALES as $locale => $label)
                                            @if ($locale === 'en' || isset($plan->translations[$locale]))
                                                <span class="rounded bg-gray-100 px-1.5 py-0.5 text-[10px] font-medium uppercase text-gray-500 dark:bg-gray-800 dark:text-gray-400">{{ $locale }}</span>
                                            @endif
                                        @endforeach
                                    </div>
                                </td>
                                <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">₹{{ $plan->price_per_month }}</span></td>
                                <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $plan->rides_included }} rides</span></td>
                                <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $plan->validity_days }} days</span></td>
                                <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $plan->subscriptions_count }}</span></td>
                                <td class="px-5 py-4 sm:px-6">
                                    <x-ui.badge :color="$plan->is_active ? 'success' : 'light'">{{ $plan->is_active ? 'Active' : 'Inactive' }}</x-ui.badge>
                                </td>
                                <td class="px-5 py-4 sm:px-6">
                                    <div class="flex items-center gap-1">
                                        <x-common.icon-button icon="edit" title="Edit" :href="route('driver-subscription-plans.edit', $plan)" />
                                        <form method="POST" action="{{ route('driver-subscription-plans.destroy', $plan) }}" id="delete-plan-{{ $plan->id }}">
                                            @csrf
                                            @method('DELETE')
                                            <x-common.icon-button
                                                icon="delete"
                                                variant="danger"
                                                title="Delete"
                                                type="button"
                                                @click="$store.confirm.ask('Delete {{ addslashes($plan->name) }}?', 'This cannot be undone.', () => document.getElementById('delete-plan-{{ $plan->id }}').requestSubmit())"
                                            />
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr><td class="px-5 py-6 text-center text-gray-500 text-theme-sm" colspan="7">No plans yet.</td></tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </x-common.component-card>
@endsection
