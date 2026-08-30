@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$title" />

    <x-common.back-link :href="route('vehicle-categories.index')" label="Back to Vehicle Categories" />

    <x-common.component-card :title="$title">
        <form method="POST" action="{{ $category->exists ? route('vehicle-categories.update', $category) : route('vehicle-categories.store') }}" enctype="multipart/form-data" class="space-y-5">
            @csrf
            @if ($category->exists) @method('PUT') @endif

            <div x-data="{ tab: 'en' }">
                <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Name &amp; Description</label>

                <div class="mb-4 flex flex-wrap gap-2">
                    @foreach (\App\Models\VehicleCategory::SUPPORTED_LOCALES as $locale => $label)
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
                    <x-form.input name="name" label="Name (English)" placeholder="Sedan" value="{{ old('name', $category->name) }}" required />
                    <div>
                        <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Description (English)</label>
                        <textarea name="description" rows="2" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('description', $category->description) }}</textarea>
                    </div>
                </div>

                @foreach (\App\Models\VehicleCategory::SUPPORTED_LOCALES as $locale => $label)
                    @continue($locale === 'en')
                    <div x-show="tab === '{{ $locale }}'" x-cloak class="space-y-5">
                        <x-form.input
                            name="translations[{{ $locale }}][name]"
                            :label="'Name (' . $label . ')'"
                            placeholder="Leave blank to fall back to English"
                            value="{{ old('translations.'.$locale.'.name', $category->translations[$locale]['name'] ?? '') }}"
                        />
                        <div>
                            <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Description ({{ $label }})</label>
                            <textarea name="translations[{{ $locale }}][description]" rows="2" placeholder="Leave blank to fall back to English" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('translations.'.$locale.'.description', $category->translations[$locale]['description'] ?? '') }}</textarea>
                        </div>
                    </div>
                @endforeach
            </div>

            <div>
                <x-form.file name="image" label="Vehicle Image" accept="image/*" />
                @if ($category->image_path)
                    <div class="mt-2 flex items-center gap-3">
                        <img src="{{ $category->image_url }}" alt="{{ $category->name }}" class="h-16 w-auto rounded-lg border border-gray-200 dark:border-gray-700" />
                        <p class="text-theme-xs text-gray-400">Uploading a new file replaces the current one.</p>
                    </div>
                @else
                    <p class="text-theme-xs text-gray-400 mt-1.5">No image uploaded yet — the customer app falls back to its bundled default image for this category.</p>
                @endif
            </div>

            <x-form.input type="number" name="seats" label="Seats" min="1" value="{{ old('seats', $category->seats) }}" required />

            <x-form.input type="number" name="base_fare" label="Base Fare (₹)" step="0.01" min="0" value="{{ old('base_fare', $category->base_fare) }}" required />

            <x-form.input type="number" name="per_km_rate" label="Per KM Rate (₹)" step="0.01" min="0" value="{{ old('per_km_rate', $category->per_km_rate) }}" required />

            <x-form.input type="number" name="per_min_rate" label="Per Minute Rate (₹)" step="0.01" min="0" value="{{ old('per_min_rate', $category->per_min_rate) }}" required />

            <x-form.checkbox name="ac" :checked="old('ac', $category->exists ? $category->ac : true)">Air Conditioned</x-form.checkbox>

            <x-ui.button type="submit">Save Category</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
