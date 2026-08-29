<div x-data="{changePassword(){
    console.log('Changing password...');
}}">
    <div class="p-5 mt-6 border border-gray-200 rounded-2xl dark:border-gray-800 lg:p-6">
        <h4 class="mb-5 text-lg font-semibold text-gray-800 dark:text-white/90 lg:mb-6">
            Change Password
        </h4>

        <form @submit.prevent="changePassword" class="grid grid-cols-1 gap-4 lg:grid-cols-2 lg:gap-7">
            <div class="col-span-2">
                <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">
                    Current Password
                </label>
                <input type="password" placeholder="Enter current password"
                    class="dark:bg-dark-900 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800" />
            </div>

            <div class="col-span-2 lg:col-span-1">
                <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">
                    New Password
                </label>
                <input type="password" placeholder="Enter new password"
                    class="dark:bg-dark-900 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800" />
            </div>

            <div class="col-span-2 lg:col-span-1">
                <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">
                    Confirm New Password
                </label>
                <input type="password" placeholder="Re-enter new password"
                    class="dark:bg-dark-900 h-11 w-full appearance-none rounded-lg border border-gray-300 bg-transparent bg-none px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800" />
            </div>

            <div class="col-span-2 flex justify-end">
                <button type="submit"
                    class="flex w-full justify-center rounded-lg bg-brand-500 px-4 py-2.5 text-sm font-medium text-white hover:bg-brand-600 sm:w-auto">
                    Update Password
                </button>
            </div>
        </form>
    </div>
</div>
