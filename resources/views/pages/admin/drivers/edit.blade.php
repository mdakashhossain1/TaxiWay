@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Edit Driver" />

    <x-common.back-link :href="route('drivers.index')" label="Back to Drivers" />

    <x-common.component-card title="Edit {{ $driver->name }}">
        <form method="POST" action="{{ route('drivers.update', $driver) }}" class="space-y-5">
            @csrf
            @method('PUT')

            <x-form.input name="name" label="Full Name" value="{{ old('name', $driver->name) }}" required />

            <x-form.input name="phone" label="Phone (10 digits)" value="{{ old('phone', $driver->phone) }}" maxlength="10" required />

            <x-form.input name="operating_area" label="Operating Area" value="{{ old('operating_area', $driver->operating_area) }}" />

            <x-form.input type="number" name="years_experience" label="Years of Experience" min="0" value="{{ old('years_experience', $driver->years_experience) }}" />

            <x-form.input name="languages" label="Languages (comma separated)" value="{{ old('languages', collect($driver->languages)->join(', ')) }}" />

            <x-ui.button type="submit">Save Changes</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
