@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$title" />

    <x-common.back-link :href="route('driver-subscription-plans.index')" label="Back to Plans" />

    <x-common.component-card :title="$title">
        <form method="POST" action="{{ $plan->exists ? route('driver-subscription-plans.update', $plan) : route('driver-subscription-plans.store') }}" class="space-y-5">
            @csrf
            @if ($plan->exists) @method('PUT') @endif

            <x-form.input type="number" name="price_per_month" label="Price (₹)" step="0.01" min="0" value="{{ old('price_per_month', $plan->price_per_month) }}" required />

            <x-form.input type="number" name="rides_included" label="Ride Quota" min="1" value="{{ old('rides_included', $plan->rides_included) }}" required />

            <div x-data="{ tab: 'en' }">
                <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Plan Name &amp; Description</label>

                <div class="mb-4 flex flex-wrap gap-2">
                    @foreach (\App\Models\DriverSubscriptionPlan::SUPPORTED_LOCALES as $locale => $label)
                        <button
                            type="button"
                            @click="tab = '{{ $locale }}'"
                            :class="tab === '{{ $locale }}' ? 'border-brand-500 bg-brand-50 text-brand-600 dark:border-brand-800 dark:bg-brand-500/10 dark:text-brand-400' : 'border-gray-200 text-gray-500 hover:border-gray-300 hover:text-gray-700 dark:border-gray-700 dark:text-gray-400 dark:hover:border-gray-600'"
                            class="rounded-lg border px-3 py-2 text-theme-sm font-medium transition-colors"
                        >{{ $label }}{{ $locale === 'en' ? '' : ' (optional)' }}</button>
                    @endforeach
                </div>

                {{-- English is the base record — always required, feeds the plain name/description columns. --}}
                <div x-show="tab === 'en'" class="space-y-5">
                    <x-form.input name="name" label="Plan Name (English)" placeholder="Basic Driver Plan" value="{{ old('name', $plan->name) }}" required />
                    <div>
                        <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Description (English)</label>
                        <textarea name="description" rows="3" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('description', $plan->description) }}</textarea>
                    </div>
                </div>

                @foreach (\App\Models\DriverSubscriptionPlan::SUPPORTED_LOCALES as $locale => $label)
                    @continue($locale === 'en')
                    <div x-show="tab === '{{ $locale }}'" x-cloak class="space-y-5">
                        <x-form.input
                            name="translations[{{ $locale }}][name]"
                            :label="'Plan Name (' . $label . ')'"
                            placeholder="Leave blank to fall back to English"
                            value="{{ old('translations.'.$locale.'.name', $plan->translations[$locale]['name'] ?? '') }}"
                        />
                        <div>
                            <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Description ({{ $label }})</label>
                            <textarea name="translations[{{ $locale }}][description]" rows="3" placeholder="Leave blank to fall back to English" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('translations.'.$locale.'.description', $plan->translations[$locale]['description'] ?? '') }}</textarea>
                        </div>
                    </div>
                @endforeach
            </div>

            <x-form.input type="number" name="validity_days" label="Validity (days)" min="1" value="{{ old('validity_days', $plan->validity_days ?? 30) }}" required />

            <x-form.checkbox name="is_active" :checked="old('is_active', $plan->exists ? $plan->is_active : true)">Active — visible for new subscriptions</x-form.checkbox>

            <x-ui.button type="submit">Save Plan</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
