@props(['name', 'label' => null, 'accept' => null])

@php
    $error = $errors->first($name);
@endphp

<div x-data="{ fileName: '' }">
    @if ($label)
        <label for="{{ $name }}" class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">{{ $label }}</label>
    @endif

    <label
        for="{{ $name }}"
        class="{{ $error ? 'border-error-300 dark:border-error-700' : 'border-gray-300 dark:border-gray-700' }} shadow-theme-xs flex h-11 w-full cursor-pointer items-center gap-3 rounded-lg border bg-transparent px-2 text-sm text-gray-500 transition-colors hover:bg-gray-50 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-white/[0.03]"
    >
        <span class="inline-flex shrink-0 items-center gap-1.5 rounded-md bg-gray-100 px-3 py-1.5 text-xs font-medium text-gray-700 dark:bg-gray-800 dark:text-gray-300">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M7 1.75V9.33333M7 1.75L4.08333 4.66667M7 1.75L9.91667 4.66667M2.33333 9.91667V10.9167C2.33333 11.4782 2.78815 11.9333 3.35 11.9333H10.65C11.2118 11.9333 11.6667 11.4782 11.6667 10.9167V9.91667" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
            Choose File
        </span>
        <span class="truncate" x-text="fileName || 'No file chosen'"></span>
    </label>

    <input
        id="{{ $name }}"
        type="file"
        name="{{ $name }}"
        @if ($accept) accept="{{ $accept }}" @endif
        class="sr-only"
        @change="fileName = $event.target.files[0]?.name || ''"
        {{ $attributes }}
    />

    @if ($error)
        <p class="text-theme-xs text-error-500 mt-1.5">{{ $error }}</p>
    @endif
</div>
