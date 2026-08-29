@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Contact Number" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />

    <x-common.component-card title="Contact Number">
        <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
            This number is what riders and drivers reach when they tap "Contact Support" or "Call Office" in the app — it's fetched live from the app config API, so no app update is needed to change it.
        </p>

        <form method="POST" action="{{ route('settings.contact.update') }}" class="space-y-5">
            @csrf

            <x-form.input name="contact_number" label="Support Phone Number" placeholder="+911800123456" value="{{ old('contact_number', $contactNumber) }}" required />

            <x-ui.button type="submit">Save Contact Number</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
