@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="SMS Gateway" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />

    <x-common.component-card title="SMS Gateway">
        <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
            Defaults are pre-filled for Fast2SMS's <code>/dev/otp/send</code> OTP endpoint — the payload template below is fully editable though, so it can match whatever fields your provider actually expects.
            Switch <strong>Live Mode</strong> off to skip sending real SMS entirely — the OTP is returned directly in the API response instead (<code>debug_otp</code>), which is handy for development/testing without spending SMS credits.
        </p>

        <form method="POST" action="{{ route('settings.sms.update') }}" class="space-y-5">
            @csrf

            <x-form.checkbox name="sms_enabled" :checked="old('sms_enabled', $smsEnabled)">
                Live Mode — actually send OTPs via the gateway below. Off = debug mode, OTP is returned in the API response instead.
            </x-form.checkbox>

            <x-form.input name="sms_payload_url" label="Payload URL" placeholder="https://www.fast2sms.com/dev/otp/send" value="{{ old('sms_payload_url', $smsPayloadUrl) }}" required />

            <x-form.input type="password" name="sms_api_key" label="API Key" placeholder="Leave blank to keep the current key — sent as the Authorization header" value="{{ old('sms_api_key') }}" />

            <x-form.input name="sms_template_id" label="Message Template ID" placeholder="Fast2SMS: your OTP Template ID (otp_id)" value="{{ old('sms_template_id', $smsTemplateId) }}" />

            <div>
                <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Payload Template (JSON)</label>
                <textarea name="sms_payload_template" rows="4" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 font-mono text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400" required>{{ old('sms_payload_template', $smsPayloadTemplate) }}</textarea>
                <p class="text-theme-xs text-gray-400 mt-1.5">
                    Placeholders <code>{otp}</code>, <code>{phone}</code>, and <code>{template_id}</code> are substituted before sending. Must be valid JSON.
                </p>
            </div>

            <x-ui.button type="submit">Save SMS Gateway Settings</x-ui.button>
        </form>
    </x-common.component-card>

    <div class="mt-6">
        <x-common.component-card title="Send Test SMS">
            <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
                Sends one real message through the gateway config saved above — ignores the Live Mode toggle, so you can verify credentials and the payload shape before turning it on for real users.
            </p>

            @if (session('smsTestResult'))
                @php $result = session('smsTestResult'); @endphp
                <div class="mb-5 rounded-lg border p-4 {{ $result['success'] ? 'border-success-200 bg-success-50 dark:border-success-800 dark:bg-success-500/10' : 'border-error-200 bg-error-50 dark:border-error-800 dark:bg-error-500/10' }}">
                    <p class="text-theme-sm font-medium {{ $result['success'] ? 'text-success-700 dark:text-success-400' : 'text-error-700 dark:text-error-400' }}">
                        {{ $result['success'] ? 'Sent successfully' : 'Failed to send' }}
                        @if ($result['status']) — HTTP {{ $result['status'] }} @endif
                    </p>
                    @if ($result['body'])
                        <pre class="mt-2 max-h-40 overflow-auto rounded bg-white/60 p-2 text-theme-xs text-gray-600 dark:bg-black/20 dark:text-gray-300">{{ $result['body'] }}</pre>
                    @endif
                </div>
            @endif

            <form method="POST" action="{{ route('settings.sms.test') }}" class="flex flex-col gap-3 sm:flex-row sm:items-end">
                @csrf
                <div class="flex-1">
                    <x-form.input name="test_phone" label="Phone Number" placeholder="10-digit number" maxlength="10" />
                </div>
                <x-ui.button type="submit" variant="outline">Send Test SMS</x-ui.button>
            </form>
        </x-common.component-card>
    </div>
@endsection
