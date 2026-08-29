<div
    x-show="$store.confirm.open"
    x-cloak
    class="fixed inset-0 z-[999999] flex items-center justify-center overflow-y-auto p-5"
    @keydown.escape.window="$store.confirm.cancel()"
>
    <div
        @click="$store.confirm.cancel()"
        class="fixed inset-0 h-full w-full bg-gray-400/50 backdrop-blur-[32px]"
        x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100" x-transition:leave="transition ease-in duration-200"
        x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0"
    ></div>

    <div
        @click.stop
        class="relative w-full max-w-md rounded-3xl bg-white p-6 dark:bg-gray-900"
        x-transition:enter="transition ease-out duration-300" x-transition:enter-start="opacity-0 transform scale-95"
        x-transition:enter-end="opacity-100 transform scale-100" x-transition:leave="transition ease-in duration-200"
        x-transition:leave-start="opacity-100 transform scale-100" x-transition:leave-end="opacity-0 transform scale-95"
    >
        <div class="flex h-12 w-12 items-center justify-center rounded-full bg-error-50 text-error-500 dark:bg-error-500/15">
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M2.75 5.5H19.25M8.25 9.625V15.125M13.75 9.625V15.125M3.66667 5.5L4.58333 17.4167C4.58333 18.4292 5.40415 19.25 6.41667 19.25H15.5833C16.5958 19.25 17.4167 18.4292 17.4167 17.4167L18.3333 5.5M7.33333 5.5V2.75C7.33333 2.24175 7.74175 1.83333 8.25 1.83333H13.75C14.2583 1.83333 14.6667 2.24175 14.6667 2.75V5.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
            </svg>
        </div>

        <h3 class="mt-4 text-lg font-semibold text-gray-800 dark:text-white/90" x-text="$store.confirm.title"></h3>
        <p class="mt-1.5 text-theme-sm text-gray-500 dark:text-gray-400" x-text="$store.confirm.message"></p>

        <div class="mt-6 flex justify-end gap-3">
            <x-ui.button size="sm" variant="outline" type="button" @click="$store.confirm.cancel()">Cancel</x-ui.button>
            <button
                type="button"
                @click="$store.confirm.confirm()"
                class="inline-flex items-center justify-center gap-2 rounded-lg bg-error-500 px-4 py-3.5 text-sm font-medium text-white transition hover:bg-error-600"
            >
                Delete
            </button>
        </div>
    </div>
</div>
