@props(['name', 'checked' => false])

<label
    x-data="{ checked: @js((bool) $checked) }"
    class="flex cursor-pointer items-center gap-3 text-sm font-medium text-gray-700 select-none dark:text-gray-400"
>
    <span class="relative">
        <input type="checkbox" name="{{ $name }}" value="1" x-model="checked" {{ $attributes->merge(['class' => 'sr-only']) }} />
        <span
            :class="checked ? 'border-brand-500 bg-brand-500' : 'bg-transparent border-gray-300 dark:border-gray-700'"
            class="hover:border-brand-500 dark:hover:border-brand-500 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] transition-colors"
        >
            <svg :class="checked ? '' : 'opacity-0'" width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11.6666 3.5L5.24992 9.91667L2.33325 7" stroke="white" stroke-width="1.94437" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
        </span>
    </span>
    {{ $slot }}
</label>
