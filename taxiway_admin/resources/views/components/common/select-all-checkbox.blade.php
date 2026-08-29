<label class="relative flex w-fit cursor-pointer items-center">
    <input
        type="checkbox"
        class="sr-only"
        @change="
            $el.closest('table').querySelectorAll('.row-check').forEach(cb => cb.checked = $event.target.checked);
            selected = $event.target.checked ? Array.from($el.closest('table').querySelectorAll('.row-check')).map(cb => cb.value) : [];
        "
    />
    <span
        :class="selected.length > 0 ? 'border-brand-500 bg-brand-500' : 'bg-transparent border-gray-300 dark:border-gray-700'"
        class="hover:border-brand-500 dark:hover:border-brand-500 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] transition-colors"
    >
        <svg :class="selected.length > 0 ? '' : 'opacity-0'" width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M11.6666 3.5L5.24992 9.91667L2.33325 7" stroke="white" stroke-width="1.94437" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
    </span>
</label>
