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
@endsection
