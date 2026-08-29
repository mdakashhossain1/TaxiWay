@props(['name', 'label' => null, 'type' => 'text', 'hint' => null])

@php
    $error = $errors->first($name);
@endphp

<div>
    @if ($label)
        <label for="{{ $name }}" class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">{{ $label }}</label>
    @endif

    <input
        type="{{ $type }}"
        id="{{ $name }}"
        name="{{ $name }}"
        {{ $attributes->merge([
            'class' => $error
                ? 'dark:bg-dark-900 border-error-300 shadow-theme-xs focus:border-error-300 focus:ring-error-500/10 dark:border-error-700 dark:focus:border-error-800 h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:text-white/90 dark:placeholder:text-white/30'
                : 'shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 dark:focus:border-brand-800 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden disabled:border-gray-100 disabled:placeholder:text-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400 dark:disabled:border-gray-800 dark:disabled:placeholder:text-white/15',
        ]) }}
    />

    @if ($error)
        <p class="text-theme-xs text-error-500 mt-1.5">{{ $error }}</p>
    @elseif ($hint)
        <p class="text-theme-xs text-gray-400 mt-1.5">{{ $hint }}</p>
    @endif
</div>
