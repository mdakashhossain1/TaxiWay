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

    <div class="mt-6">
        <x-common.component-card title="Test Firebase Connection">
            <p class="mb-5 text-theme-sm text-gray-500 dark:text-gray-400">
                Signs in as the service account above and writes a throwaway test document to Firestore — catches a wrong Project ID, a missing/invalid key file, or a revoked key now instead of at the first real chat message.
            </p>

            @if (session('firebaseTestResult'))
                @php $result = session('firebaseTestResult'); @endphp
                <div class="mb-5 rounded-lg border p-4 {{ $result['success'] ? 'border-success-200 bg-success-50 dark:border-success-800 dark:bg-success-500/10' : 'border-error-200 bg-error-50 dark:border-error-800 dark:bg-error-500/10' }}">
                    <p class="text-theme-sm font-medium {{ $result['success'] ? 'text-success-700 dark:text-success-400' : 'text-error-700 dark:text-error-400' }}">
                        {{ $result['success'] ? 'Connected' : 'Failed' }}
                    </p>
                    <pre class="mt-2 max-h-40 overflow-auto rounded bg-white/60 p-2 text-theme-xs text-gray-600 dark:bg-black/20 dark:text-gray-300">{{ $result['message'] }}</pre>
                </div>
            @endif

            <form method="POST" action="{{ route('settings.firebase.test') }}">
                @csrf
                <x-ui.button type="submit" variant="outline">Test Firebase Connection</x-ui.button>
            </form>
        </x-common.component-card>
    </div>
@endsection
