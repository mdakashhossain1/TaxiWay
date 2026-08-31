@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="SMS Gateway" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />

    <x-common.component-card title="SMS Gateway">
        <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
            Both a non-DLT quick OTP route and a TRAI DLT-registered template route can be configured below at the same
            time — <strong>Active Route</strong> picks which one OtpService actually sends through, and switching it
            later doesn't lose the other profile's settings.
            Switch <strong>Live Mode</strong> off to skip sending real SMS entirely — the OTP is returned directly in the
            API response instead (<code>debug_otp</code>), which is handy for development/testing without spending SMS credits.
        </p>

        <form method="POST" action="{{ route('settings.sms.update') }}" class="space-y-6">
            @csrf

            <x-form.checkbox name="sms_enabled" :checked="old('sms_enabled', $smsEnabled)">
                Live Mode — actually send OTPs via the active route below. Off = debug mode, OTP is returned in the API response instead.
            </x-form.checkbox>

            <div class="grid gap-5 sm:grid-cols-2">
                <x-form.select name="sms_mode" label="Active Route">
                    <option value="otp" @selected(old('sms_mode', $smsMode) === 'otp')>OTP route (non-DLT)</option>
                    <option value="dlt" @selected(old('sms_mode', $smsMode) === 'dlt')>DLT route (registered template)</option>
                </x-form.select>

                <x-form.input type="password" name="sms_api_key" label="API Key" placeholder="Leave blank to keep the current key — sent as the Authorization header, shared by both routes" value="{{ old('sms_api_key') }}" />
            </div>

            <div class="rounded-xl border border-gray-200 p-5 dark:border-gray-800">
                <h4 class="mb-4 text-base font-medium text-gray-800 dark:text-white/90">OTP route (non-DLT)</h4>

                <div class="space-y-5">
                    <x-form.input name="otp_payload_url" label="Payload URL" placeholder="https://www.fast2sms.com/dev/bulkV2" value="{{ old('otp_payload_url', $otpPayloadUrl) }}" />

                    <x-form.input name="otp_template_id" label="Message Template ID" placeholder="Only if your provider needs one for this route — Fast2SMS's OTP route doesn't" value="{{ old('otp_template_id', $otpTemplateId) }}" />

                    <div>
                        <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Payload Template (JSON)</label>
                        <textarea name="otp_payload_template" rows="4" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 font-mono text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('otp_payload_template', $otpPayloadTemplate) }}</textarea>
                        <p class="text-theme-xs text-gray-400 mt-1.5">
                            Placeholders <code>{otp}</code>, <code>{phone}</code>, and <code>{template_id}</code> are substituted before sending. Must be valid JSON.
                        </p>
                        @error('otp_payload_template')
                            <p class="text-theme-xs text-error-500 mt-1.5">{{ $message }}</p>
                        @enderror
                    </div>
                </div>
            </div>

            <div class="rounded-xl border border-gray-200 p-5 dark:border-gray-800">
                <h4 class="mb-4 text-base font-medium text-gray-800 dark:text-white/90">DLT route (registered template)</h4>

                <div class="space-y-5">
                    <x-form.input name="dlt_payload_url" label="Payload URL" placeholder="https://www.fast2sms.com/bulkV2" value="{{ old('dlt_payload_url', $dltPayloadUrl) }}" />

                    <div class="grid gap-5 sm:grid-cols-3">
                        <x-form.input name="dlt_template_id" label="DLT Template ID" placeholder="Your TRAI DLT-approved template/message ID" value="{{ old('dlt_template_id', $dltTemplateId) }}" />
                        <x-form.input name="dlt_sender_id" label="DLT Sender ID" placeholder="Your registered 6-character sender ID" value="{{ old('dlt_sender_id', $dltSenderId) }}" />
                        <x-form.input name="dlt_entity_id" label="DLT Entity / PE ID" placeholder="Only if your provider requires it in the payload" value="{{ old('dlt_entity_id', $dltEntityId) }}" />
                    </div>

                    <div>
                        <label class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400">Payload Template (JSON)</label>
                        <textarea name="dlt_payload_template" rows="4" class="shadow-theme-xs focus:border-brand-300 focus:ring-brand-500/10 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 font-mono text-sm text-gray-800 placeholder:text-gray-400 focus:ring-3 focus:outline-hidden dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-gray-400">{{ old('dlt_payload_template', $dltPayloadTemplate) }}</textarea>
                        <p class="text-theme-xs text-gray-400 mt-1.5">
                            Placeholders <code>{otp}</code>, <code>{phone}</code>, <code>{template_id}</code>, <code>{sender_id}</code>, and <code>{entity_id}</code> are substituted before sending. Must match the exact wording your DLT template was approved with — must be valid JSON.
                        </p>
                        @error('dlt_payload_template')
                            <p class="text-theme-xs text-error-500 mt-1.5">{{ $message }}</p>
                        @enderror
                    </div>
                </div>
            </div>

            <x-ui.button type="submit">Save SMS Gateway Settings</x-ui.button>
        </form>
    </x-common.component-card>

    <div class="mt-6">
        <x-common.component-card title="Send Test SMS">
            <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
                Sends one real message through the chosen route's saved config above — ignores the Live Mode toggle, so
                you can verify credentials and the payload shape before turning it on for real users.
            </p>

            @if (session('smsTestResult'))
                @php $result = session('smsTestResult'); @endphp
                <div class="mb-5 rounded-lg border p-4 {{ $result['success'] ? 'border-success-200 bg-success-50 dark:border-success-800 dark:bg-success-500/10' : 'border-error-200 bg-error-50 dark:border-error-800 dark:bg-error-500/10' }}">
                    <p class="text-theme-sm font-medium {{ $result['success'] ? 'text-success-700 dark:text-success-400' : 'text-error-700 dark:text-error-400' }}">
                        {{ $result['success'] ? 'Sent successfully' : 'Failed to send' }} via {{ strtoupper($result['mode'] ?? $smsMode) }} route
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
                <div class="sm:w-56">
                    <x-form.select name="test_mode" label="Route to test">
                        <option value="" @selected(true)>Active route ({{ strtoupper($smsMode) }})</option>
                        <option value="otp">OTP route (non-DLT)</option>
                        <option value="dlt">DLT route</option>
                    </x-form.select>
                </div>
                <x-ui.button type="submit" variant="outline">Send Test SMS</x-ui.button>
            </form>
        </x-common.component-card>
    </div>
@endsection
