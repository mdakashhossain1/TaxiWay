@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Firebase Credentials" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />


    <x-common.component-card title="Firebase Credentials">
        <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
            Used for Google Sign-In verification (Project ID) and for sending push notifications via FCM (service-account JSON). Uploading a new file replaces the current one.
        </p>

        <form method="POST" action="{{ route('settings.firebase.update') }}" enctype="multipart/form-data" class="space-y-5">
            @csrf

            <x-form.input name="firebase_project_id" label="Firebase Project ID" value="{{ old('firebase_project_id', $firebaseProjectId) }}" required />

            <x-form.input name="firebase_web_api_key" label="Web API Key" placeholder="From Firebase Console > Project Settings > General > Web app" value="{{ old('firebase_web_api_key', $firebaseWebApiKey) }}" />
            <p class="text-theme-xs text-gray-400 -mt-3">
                Public browser key (not a secret) used by the admin panel's Support Chat page to sign in and read/send Firestore messages client-side.
            </p>

            <div>
                <x-form.file name="credentials_file" label="Service Account JSON" accept="application/json" />
                <p class="text-theme-xs text-gray-400 mt-1.5">
                    @if ($firebaseCredentialsConfigured)
                        A credentials file is currently configured (last updated {{ \Illuminate\Support\Carbon::createFromTimestamp($firebaseCredentialsUpdatedAt)->format('d M Y, h:i A') }}). Leave this empty to keep it.
                    @else
                        No credentials file uploaded yet — push notifications will not work until one is provided.
                    @endif
                </p>
            </div>

            <x-ui.button type="submit">Save Firebase Settings</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
