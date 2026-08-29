@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Add Driver" />

    <x-common.back-link :href="route('drivers.index')" label="Back to Drivers" />

    <x-common.component-card title="New Driver">
        <form method="POST" action="{{ route('drivers.store') }}" class="space-y-5">
            @csrf

            <x-form.input name="name" label="Full Name" value="{{ old('name') }}" required />

            <x-form.input name="phone" label="Phone (10 digits)" value="{{ old('phone') }}" maxlength="10" required />

            <x-form.input name="operating_area" label="Operating Area" value="{{ old('operating_area') }}" />

            <x-form.input type="number" name="years_experience" label="Years of Experience" min="0" value="{{ old('years_experience') }}" />

            <p class="text-sm text-gray-500 dark:text-gray-400">The driver is added with <strong>pending</strong> verification and cannot log in to the driver app until you verify them.</p>

            <x-ui.button type="submit">Add Driver</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
