@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Settings" />


    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <a href="{{ route('settings.firebase.edit') }}"
            class="group flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 transition-colors hover:border-brand-300 dark:border-gray-800 dark:bg-white/[0.03] dark:hover:border-brand-800">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <circle cx="7" cy="13" r="3" stroke="currentColor" stroke-width="1.3" />
                            <path d="M9.5 10.5L16 4M16 4V7M16 4H13" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </span>
                    <x-ui.badge size="sm" :color="$firebaseConfigured ? 'success' : 'warning'">{{ $firebaseConfigured ? 'Configured' : 'Not configured' }}</x-ui.badge>
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">Firebase Credentials</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">Google Sign-In verification and push notification credentials.</p>
            </div>
            <span class="mt-4 inline-flex items-center gap-1 text-theme-sm font-medium text-brand-600 transition-all group-hover:gap-2 dark:text-brand-400">
                Edit
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5.25 3.5L8.75 7L5.25 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
        </a>

        <a href="{{ route('settings.mail.edit') }}"
            class="group flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 transition-colors hover:border-brand-300 dark:border-gray-800 dark:bg-white/[0.03] dark:hover:border-brand-800">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M3.5 5.5h13a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1h-13a1 1 0 0 1-1-1v-7a1 1 0 0 1 1-1Z" stroke="currentColor" stroke-width="1.3" />
                            <path d="M3 6L10 11L17 6" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </span>
                    <x-ui.badge size="sm" :color="$mailConfigured ? 'success' : 'warning'">{{ $mailConfigured ? 'Configured' : 'Not configured' }}</x-ui.badge>
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">Mail Settings</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">SMTP details used for driver notification emails, e.g. on verification.</p>
            </div>
            <span class="mt-4 inline-flex items-center gap-1 text-theme-sm font-medium text-brand-600 transition-all group-hover:gap-2 dark:text-brand-400">
                Edit
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5.25 3.5L8.75 7L5.25 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
        </a>

        <a href="{{ route('settings.sms.edit') }}"
            class="group flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 transition-colors hover:border-brand-300 dark:border-gray-800 dark:bg-white/[0.03] dark:hover:border-brand-800">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M6 3.5h8a1.5 1.5 0 0 1 1.5 1.5v10a1.5 1.5 0 0 1-1.5 1.5H6A1.5 1.5 0 0 1 4.5 15V5A1.5 1.5 0 0 1 6 3.5Z" stroke="currentColor" stroke-width="1.3" />
                            <path d="M8.5 15.75h3" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" />
                        </svg>
                    </span>
                    <x-ui.badge size="sm" :color="$smsGatewayEnabled ? 'success' : 'warning'">{{ $smsGatewayEnabled ? 'Live' : 'Debug mode' }}</x-ui.badge>
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">SMS Gateway</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">OTP delivery — payload URL, API key, and template, or debug mode.</p>
            </div>
            <span class="mt-4 inline-flex items-center gap-1 text-theme-sm font-medium text-brand-600 transition-all group-hover:gap-2 dark:text-brand-400">
                Edit
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5.25 3.5L8.75 7L5.25 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
        </a>

        <a href="{{ route('settings.contact.edit') }}"
            class="group flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 transition-colors hover:border-brand-300 dark:border-gray-800 dark:bg-white/[0.03] dark:hover:border-brand-800">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M5 4.5h2.5l1 3.5-1.75 1.25a8 8 0 0 0 4 4l1.25-1.75 3.5 1V16a1.5 1.5 0 0 1-1.5 1.5C9.5 17.5 3.5 11.5 3.5 6A1.5 1.5 0 0 1 5 4.5Z" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </span>
                    <x-ui.badge size="sm" :color="$contactConfigured ? 'success' : 'warning'">{{ $contactConfigured ? 'Configured' : 'Not configured' }}</x-ui.badge>
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">Contact Number</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">Support phone number the apps dial for "Contact Support" / "Call Office".</p>
            </div>
            <span class="mt-4 inline-flex items-center gap-1 text-theme-sm font-medium text-brand-600 transition-all group-hover:gap-2 dark:text-brand-400">
                Edit
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5.25 3.5L8.75 7L5.25 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
        </a>

        <a href="{{ route('settings.support-chat.index') }}"
            class="group flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 transition-colors hover:border-brand-300 dark:border-gray-800 dark:bg-white/[0.03] dark:hover:border-brand-800">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M4 15.5V6.5a1.5 1.5 0 0 1 1.5-1.5h9A1.5 1.5 0 0 1 16 6.5v6a1.5 1.5 0 0 1-1.5 1.5H8l-3 3v-1.5H5.5A1.5 1.5 0 0 1 4 15.5Z" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </span>
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">Support Chat</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">Live inbox for rider/driver "Message Support" conversations.</p>
            </div>
            <span class="mt-4 inline-flex items-center gap-1 text-theme-sm font-medium text-brand-600 transition-all group-hover:gap-2 dark:text-brand-400">
                Open
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5.25 3.5L8.75 7L5.25 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
        </a>

        <a href="{{ route('email-templates.index') }}"
            class="group flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 transition-colors hover:border-brand-300 dark:border-gray-800 dark:bg-white/[0.03] dark:hover:border-brand-800">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-brand-50 text-brand-600 dark:bg-brand-500/10 dark:text-brand-400">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M4.5 6.5h11a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1h-11a1 1 0 0 1-1-1v-5a1 1 0 0 1 1-1Z" stroke="currentColor" stroke-width="1.3" />
                            <path d="M6.5 9.5h7M6.5 12h4.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" />
                        </svg>
                    </span>
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">Email Templates</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">Edit the subject/heading/body of automated emails, per language.</p>
            </div>
            <span class="mt-4 inline-flex items-center gap-1 text-theme-sm font-medium text-brand-600 transition-all group-hover:gap-2 dark:text-brand-400">
                Edit
                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M5.25 3.5L8.75 7L5.25 10.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </span>
        </a>

        <div class="flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03]">
            <div>
                <div class="flex items-start justify-between">
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-300">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M4 6.5C4 5.11929 6.68629 4 10 4C13.3137 4 16 5.11929 16 6.5C16 7.88071 13.3137 9 10 9C6.68629 9 4 7.88071 4 6.5Z" stroke="currentColor" stroke-width="1.3" />
                            <path d="M4 6.5V13.5C4 14.8807 6.68629 16 10 16C13.3137 16 16 14.8807 16 13.5V6.5" stroke="currentColor" stroke-width="1.3" />
                            <path d="M16 10C16 11.3807 13.3137 12.5 10 12.5C6.68629 12.5 4 11.3807 4 10" stroke="currentColor" stroke-width="1.3" />
                        </svg>
                    </span>
                    @if ($pendingMigrations === null)
                        <x-ui.badge size="sm" color="error">Unable to check</x-ui.badge>
                    @elseif (count($pendingMigrations) === 0)
                        <x-ui.badge size="sm" color="success">Up to date</x-ui.badge>
                    @else
                        <x-ui.badge size="sm" color="warning">{{ count($pendingMigrations) }} pending</x-ui.badge>
                    @endif
                </div>
                <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">Database Migrations</h3>
                <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">Apply schema changes after uploading new code — run this instead of SSH access.</p>
                @if ($pendingMigrations)
                    <ul class="mt-2 space-y-0.5 text-theme-xs text-gray-400">
                        @foreach ($pendingMigrations as $migration)
                            <li class="truncate">{{ $migration }}</li>
                        @endforeach
                    </ul>
                @endif
            </div>

            <form id="run-migrations-form" method="POST" action="{{ route('settings.migrate') }}" class="mt-4">
                @csrf
            </form>
            <x-ui.button
                size="sm"
                variant="outline"
                type="button"
                className="mt-4 w-full"
                @click="$store.confirm.ask('Run database migrations?', 'This applies pending schema changes directly to the live database. Make sure you have backed up before continuing.', () => document.getElementById('run-migrations-form').requestSubmit())"
            >Run Migrations</x-ui.button>
        </div>

        @foreach ($cacheActions as $action => [$label, $desc, $command])
            <form method="POST" action="{{ route('settings.cache') }}"
                class="flex flex-col justify-between rounded-2xl border border-gray-200 bg-white p-5 dark:border-gray-800 dark:bg-white/[0.03]">
                @csrf
                <input type="hidden" name="action" value="{{ $action }}" />
                <div>
                    <span class="flex h-10 w-10 items-center justify-center rounded-lg bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-300">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M16.5 10C16.5 13.5899 13.5899 16.5 10 16.5C6.41015 16.5 3.5 13.5899 3.5 10C3.5 6.41015 6.41015 3.5 10 3.5C12.3053 3.5 14.328 4.703 15.478 6.522M15.478 6.522V3.5M15.478 6.522H12.5" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </span>
                    <h3 class="mt-4 font-semibold text-gray-800 dark:text-white/90">{{ $label }}</h3>
                    <p class="mt-1 text-theme-sm text-gray-500 dark:text-gray-400">{{ $desc }}</p>
                </div>
                <x-ui.button size="sm" variant="outline" type="submit" className="mt-4 w-full">Clear</x-ui.button>
            </form>
        @endforeach
    </div>

    @unless ($opcacheEnabled)
        <p class="mt-4 text-theme-xs text-gray-400">PHP OPcache is not enabled on this server, so "Everything" skips it.</p>
    @endunless
@endsection
