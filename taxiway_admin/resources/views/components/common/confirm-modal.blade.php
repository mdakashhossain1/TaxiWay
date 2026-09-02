<dialog
    id="confirm-modal"
    class="fixed inset-0 m-0 h-full max-h-none w-full max-w-none overflow-y-auto bg-transparent p-0 backdrop:bg-transparent"
>
    <div class="fixed inset-0 bg-gray-500/75"></div>

    <div class="flex min-h-full items-center justify-center p-5">
        <div
            @click.outside="$store.confirm.cancel()"
            class="relative w-full max-w-md rounded-3xl bg-white p-6 dark:bg-gray-900"
        >
            <div
                class="flex h-12 w-12 items-center justify-center rounded-full"
                :class="$store.confirm.variant === 'danger' ? 'bg-error-50 text-error-500 dark:bg-error-500/15' : 'bg-brand-50 text-brand-500 dark:bg-brand-500/15'"
            >
                <svg x-show="$store.confirm.variant === 'danger'" width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M2.75 5.5H19.25M8.25 9.625V15.125M13.75 9.625V15.125M3.66667 5.5L4.58333 17.4167C4.58333 18.4292 5.40415 19.25 6.41667 19.25H15.5833C16.5958 19.25 17.4167 18.4292 17.4167 17.4167L18.3333 5.5M7.33333 5.5V2.75C7.33333 2.24175 7.74175 1.83333 8.25 1.83333H13.75C14.2583 1.83333 14.6667 2.24175 14.6667 2.75V5.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <svg x-show="$store.confirm.variant !== 'danger'" width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M11 20.1667C16.0626 20.1667 20.1667 16.0626 20.1667 11C20.1667 5.93743 16.0626 1.83333 11 1.83333C5.93743 1.83333 1.83333 5.93743 1.83333 11C1.83333 16.0626 5.93743 20.1667 11 20.1667Z" stroke="currentColor" stroke-width="1.5" />
                    <path d="M11 7.33333V11.9167M11 14.6667H11.0092" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </div>

            <h3 class="mt-4 text-lg font-semibold text-gray-800 dark:text-white/90" x-text="$store.confirm.title"></h3>
            <p class="mt-1.5 text-theme-sm text-gray-500 dark:text-gray-400" x-text="$store.confirm.message"></p>

            <div class="mt-6 flex justify-end gap-3">
                <x-ui.button size="sm" variant="outline" type="button" @click="$store.confirm.cancel()">Cancel</x-ui.button>
                <button
                    type="button"
                    @click="$store.confirm.confirm()"
                    class="inline-flex items-center justify-center gap-2 rounded-lg px-4 py-3.5 text-sm font-medium text-white transition"
                    :class="$store.confirm.variant === 'danger' ? 'bg-error-500 hover:bg-error-600' : 'bg-brand-500 hover:bg-brand-600'"
                    x-text="$store.confirm.confirmLabel"
                ></button>
            </div>
        </div>
    </div>
</dialog>
