@props(['href', 'label' => 'Back'])

<a href="{{ $href }}" class="mb-4 inline-flex items-center gap-1.5 text-theme-sm font-medium text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
    <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M8.75 3.5L5.25 7L8.75 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
    </svg>
    {{ $label }}
</a>
