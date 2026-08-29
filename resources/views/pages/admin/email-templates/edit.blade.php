@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$title" />

    <x-common.back-link :href="route('email-templates.index')" label="Back to Email Templates" />

    <x-common.component-card :title="$title">
        <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
            Use <code>{driver_name}</code> and <code>{app_name}</code> as placeholders — they're replaced with real values when the email is sent.
        </p>

        <form method="POST" action="{{ route('email-templates.update', $template) }}" class="space-y-5">
            @csrf
            @method('PUT')

            <div x-data="{ tab: 'en' }">
                <div class="mb-4 flex flex-wrap gap-2">
                    @foreach (\App\Support\Locale::SUPPORTED as $locale => $label)
                        <button
                            type="button"
                            @click="tab = '{{ $locale }}'"
                            :class="tab === '{{ $locale }}' ? 'border-brand-500 bg-brand-50 text-brand-600 dark:border-brand-800 dark:bg-brand-500/10 dark:text-brand-400' : 'border-gray-200 text-gray-500 hover:border-gray-300 hover:text-gray-700 dark:border-gray-700 dark:text-gray-400 dark:hover:border-gray-600'"
                            class="rounded-lg border px-3 py-2 text-theme-sm font-medium transition-colors"
                        >{{ $label }}{{ $locale === 'en' ? '' : ' (optional)' }}</button>
                    @endforeach
                </div>

                <div x-show="tab === 'en'" class="space-y-5">
                    <x-form.input name="subject" label="Subject (English)" value="{{ old('subject', $template->subject) }}" required />
                    <x-form.input name="heading" label="Heading (English)" value="{{ old('heading', $template->heading) }}" required />
                    <div>
                        <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Body (English)</label>
                        <textarea name="body" rows="6" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400" required>{{ old('body', $template->body) }}</textarea>
                    </div>
                </div>

                @foreach (\App\Support\Locale::SUPPORTED as $locale => $label)
                    @continue($locale === 'en')
                    <div x-show="tab === '{{ $locale }}'" x-cloak class="space-y-5">
                        <x-form.input
                            name="translations[{{ $locale }}][subject]"
                            :label="'Subject (' . $label . ')'"
                            placeholder="Leave blank to fall back to English"
                            value="{{ old('translations.'.$locale.'.subject', $template->translations[$locale]['subject'] ?? '') }}"
                        />
                        <x-form.input
                            name="translations[{{ $locale }}][heading]"
                            :label="'Heading (' . $label . ')'"
                            placeholder="Leave blank to fall back to English"
                            value="{{ old('translations.'.$locale.'.heading', $template->translations[$locale]['heading'] ?? '') }}"
                        />
                        <div>
                            <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Body ({{ $label }})</label>
                            <textarea name="translations[{{ $locale }}][body]" rows="6" placeholder="Leave blank to fall back to English" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('translations.'.$locale.'.body', $template->translations[$locale]['body'] ?? '') }}</textarea>
                        </div>
                    </div>
                @endforeach
            </div>

            <x-ui.button type="submit">Save Template</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
