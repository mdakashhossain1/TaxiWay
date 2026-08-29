@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Mail Settings" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />

    <x-common.component-card title="Mail Settings">
        <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
            SMTP details used to send notification emails — for example, letting a driver know their account has been verified. Without this configured, emails are only written to the log file, not actually delivered.
        </p>

        <form method="POST" action="{{ route('settings.mail.update') }}" class="space-y-5">
            @csrf

            <x-form.input name="mail_host" label="SMTP Host" value="{{ old('mail_host', $mailHost) }}" required />
            <x-form.input type="number" name="mail_port" label="SMTP Port" value="{{ old('mail_port', $mailPort) }}" required />
            <x-form.input name="mail_username" label="SMTP Username" value="{{ old('mail_username', $mailUsername) }}" required />
            <x-form.input type="password" name="mail_password" label="SMTP Password" placeholder="Leave blank to keep the current password" />
            <x-form.input type="email" name="mail_from_address" label="From Address" value="{{ old('mail_from_address', $mailFromAddress) }}" required />
            <x-form.input name="mail_from_name" label="From Name" value="{{ old('mail_from_name', $mailFromName) }}" required />

            <x-ui.button type="submit">Save Mail Settings</x-ui.button>
        </form>
    </x-common.component-card>

    <div class="mt-6">
        <x-common.component-card title="Queue Status">
            <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
                Driver verification emails are queued (not sent immediately) — a scheduled <code>queue:work</code> run processes them once a minute. Since this runs from an external server over HTTP rather than a local crontab, point it at this URL once a minute (set <code>CRON_SECRET</code> in <code>.env</code> first):
            </p>
            <pre class="mb-5 overflow-auto rounded bg-gray-50 p-3 text-theme-xs text-gray-600 dark:bg-white/5 dark:text-gray-300">curl "https://cornflowerblue-stingray-110031.hostingersite.com/cron/run?token=YOUR_CRON_SECRET"</pre>

            <div class="mb-5 grid grid-cols-3 gap-4 text-center">
                <div class="rounded-lg border border-gray-200 p-3 dark:border-gray-700">
                    <p class="text-theme-xs text-gray-400">Connection</p>
                    <p class="font-medium text-gray-800 dark:text-white/90">{{ $queueConnection }}</p>
                </div>
                <div class="rounded-lg border border-gray-200 p-3 dark:border-gray-700">
                    <p class="text-theme-xs text-gray-400">Pending jobs</p>
                    <p class="font-medium text-gray-800 dark:text-white/90">{{ $queuePendingCount ?? 'unreadable' }}</p>
                </div>
                <div class="rounded-lg border border-gray-200 p-3 dark:border-gray-700">
                    <p class="text-theme-xs text-gray-400">Failed jobs</p>
                    <p class="font-medium {{ ($queueFailedCount ?? 0) > 0 ? 'text-error-600' : 'text-gray-800 dark:text-white/90' }}">{{ $queueFailedCount ?? 'unreadable' }}</p>
                </div>
            </div>

            @if (session('queueTestResult'))
                @php $result = session('queueTestResult'); @endphp
                <div class="mb-5 rounded-lg border p-4 {{ $result['success'] ? 'border-success-200 bg-success-50 dark:border-success-800 dark:bg-success-500/10' : 'border-error-200 bg-error-50 dark:border-error-800 dark:bg-error-500/10' }}">
                    <p class="text-theme-sm font-medium {{ $result['success'] ? 'text-success-700 dark:text-success-400' : 'text-error-700 dark:text-error-400' }}">
                        {{ $result['success'] ? 'Dispatched' : 'Failed' }}
                    </p>
                    <p class="mt-1 text-theme-xs text-gray-600 dark:text-gray-300">{{ $result['message'] }}</p>
                </div>
            @endif

            <form method="POST" action="{{ route('settings.mail.test-queue') }}">
                @csrf
                <x-ui.button type="submit" variant="outline">Dispatch Test Queue Job</x-ui.button>
            </form>
        </x-common.component-card>
    </div>
@endsection
