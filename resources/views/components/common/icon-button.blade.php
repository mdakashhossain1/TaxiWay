@props(['icon', 'title', 'href' => null, 'variant' => 'neutral'])

@php
    $icons = [
        'view' => '<path d="M1 9C1 9 4 3 9 3C14 3 17 9 17 9C17 9 14 15 9 15C4 15 1 9 1 9Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="9" cy="9" r="2.5" stroke="currentColor" stroke-width="1.5"/>',
        'edit' => '<path d="M12.4142 2.58579C13.1953 1.80474 14.4616 1.80474 15.2426 2.58579C16.0237 3.36683 16.0237 4.63316 15.2426 5.41421L6.5 14.1569L2.5 15.5L3.84315 11.5L12.4142 2.58579Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>',
        'delete' => '<path d="M2.5 4.5H15.5M7 2H11C11.2761 2 11.5 2.22386 11.5 2.5V4.5H6.5V2.5C6.5 2.22386 6.72386 2 7 2ZM3.5 4.5L4.16667 15.1042C4.20156 15.6197 4.6289 16 5.14545 16H12.8545C13.3711 16 13.7984 15.6197 13.8333 15.1042L14.5 4.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><path d="M7.5 7.5V12.5M10.5 7.5V12.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>',
    ];

    $variants = [
        'neutral' => 'text-gray-500 hover:bg-gray-100 hover:text-gray-700 dark:text-gray-400 dark:hover:bg-white/5 dark:hover:text-gray-200',
        'danger' => 'text-error-500 hover:bg-error-50 hover:text-error-600 dark:hover:bg-error-500/10',
    ];

    $tag = $href ? 'a' : 'button';
@endphp

<{{ $tag }}
    @if ($href) href="{{ $href }}" @endif
    title="{{ $title }}"
    aria-label="{{ $title }}"
    {{ $attributes->merge(['class' => 'inline-flex h-8 w-8 items-center justify-center rounded-lg transition-colors ' . ($variants[$variant] ?? $variants['neutral'])]) }}
>
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
        {!! $icons[$icon] ?? '' !!}
    </svg>
</{{ $tag }}>
