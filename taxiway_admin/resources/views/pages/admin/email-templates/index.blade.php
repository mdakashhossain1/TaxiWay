@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Email Templates" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />

    <x-common.component-card title="Email Templates">
        <p class="mb-4 text-theme-sm text-gray-500 dark:text-gray-400">
            Text sent in automated emails, editable per language. Leave a translation blank to fall back to English.
        </p>

        <div class="overflow-hidden rounded-xl border border-gray-200 dark:border-gray-800">
            <div class="max-w-full overflow-x-auto custom-scrollbar">
                <table class="w-full min-w-[600px]">
                    <thead>
                        <tr class="border-b border-gray-100 dark:border-gray-800">
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Template</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Subject</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"><p class="font-medium text-gray-500 text-theme-xs dark:text-gray-400">Languages</p></th>
                            <th class="px-5 py-3 text-left sm:px-6"></th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($templates as $template)
                            <tr class="border-b border-gray-100 dark:border-gray-800">
                                <td class="px-5 py-4 sm:px-6"><span class="font-medium text-gray-800 text-theme-sm dark:text-white/90">{{ $labels[$template->key] ?? $template->key }}</span></td>
                                <td class="px-5 py-4 sm:px-6"><span class="text-gray-500 text-theme-sm dark:text-gray-400">{{ $template->subject }}</span></td>
                                <td class="px-5 py-4 sm:px-6">
                                    <div class="flex gap-1">
                                        @foreach (\App\Support\Locale::SUPPORTED as $locale => $label)
                                            @if ($locale === 'en' || isset($template->translations[$locale]))
                                                <span class="rounded bg-gray-100 px-1.5 py-0.5 text-[10px] font-medium uppercase text-gray-500 dark:bg-gray-800 dark:text-gray-400">{{ $locale }}</span>
                                            @endif
                                        @endforeach
                                    </div>
                                </td>
                                <td class="px-5 py-4 sm:px-6">
                                    <x-common.icon-button icon="edit" title="Edit" :href="route('email-templates.edit', $template)" />
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </x-common.component-card>
@endsection
