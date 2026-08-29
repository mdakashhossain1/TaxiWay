@props(['searchAction', 'bulkDeleteAction', 'searchPlaceholder' => 'Search...', 'searchParams' => ['q']])

<div
    x-data="{ selected: [], density: localStorage.getItem('table-density') || 'comfortable' }"
    :class="density === 'compact' ? 'density-compact' : ''"
>
    <form method="GET" action="{{ $searchAction }}" class="flex flex-wrap items-end gap-3 mb-4">
        <div class="flex-1 min-w-[220px]">
            <input
                type="text"
                name="q"
                value="{{ request('q') }}"
                placeholder="{{ $searchPlaceholder }}"
                class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 h-10 w-full rounded-lg border border-gray-300 bg-transparent px-4 text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400"
            />
        </div>

        {{ $filters ?? '' }}

        <x-ui.button size="sm" variant="outline" type="submit">Search</x-ui.button>

        @if (collect($searchParams)->contains(fn ($param) => filled(request($param))))
            <a href="{{ $searchAction }}" class="text-theme-sm text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">Clear</a>
        @endif

        <div class="ml-auto flex items-center gap-1 rounded-lg bg-gray-100 p-1 dark:bg-gray-900">
            <button
                type="button"
                title="Comfortable rows"
                @click="density = 'comfortable'; localStorage.setItem('table-density', 'comfortable')"
                :class="density === 'comfortable' ? 'bg-white text-gray-800 shadow-theme-xs dark:bg-gray-800 dark:text-white' : 'text-gray-500 dark:text-gray-400'"
                class="flex h-8 w-8 items-center justify-center rounded-md transition-colors"
            >
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="2" y="3" width="12" height="2" rx="1" fill="currentColor" /><rect x="2" y="7" width="12" height="2" rx="1" fill="currentColor" /><rect x="2" y="11" width="12" height="2" rx="1" fill="currentColor" />
                </svg>
            </button>
            <button
                type="button"
                title="Compact rows"
                @click="density = 'compact'; localStorage.setItem('table-density', 'compact')"
                :class="density === 'compact' ? 'bg-white text-gray-800 shadow-theme-xs dark:bg-gray-800 dark:text-white' : 'text-gray-500 dark:text-gray-400'"
                class="flex h-8 w-8 items-center justify-center rounded-md transition-colors"
            >
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="2" y="2" width="12" height="1.5" rx="0.75" fill="currentColor" /><rect x="2" y="5.5" width="12" height="1.5" rx="0.75" fill="currentColor" /><rect x="2" y="9" width="12" height="1.5" rx="0.75" fill="currentColor" /><rect x="2" y="12.5" width="12" height="1.5" rx="0.75" fill="currentColor" />
                </svg>
            </button>
        </div>
    </form>

    <div x-show="selected.length > 0" x-cloak x-transition
        class="mb-3 flex items-center justify-between rounded-lg bg-brand-50 px-4 py-2.5 dark:bg-brand-500/10">
        <span class="text-theme-sm font-medium text-brand-700 dark:text-brand-400" x-text="selected.length + ' selected'"></span>
        <button
            type="button"
            @click="$store.confirm.ask('Delete ' + selected.length + ' selected record(s)?', 'This cannot be undone.', () => document.getElementById('bulk-delete-form').requestSubmit())"
            class="text-theme-sm font-medium text-error-600 hover:text-error-700 dark:text-error-500"
        >
            Delete Selected
        </button>
    </div>

    <form id="bulk-delete-form" method="POST" action="{{ $bulkDeleteAction }}">
        @csrf
        @method('DELETE')
        {{ $slot }}
    </form>
</div>
