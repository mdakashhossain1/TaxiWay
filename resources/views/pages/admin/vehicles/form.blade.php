@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$title" />

    <x-common.back-link :href="route('vehicles.index')" label="Back to Vehicles" />

    <x-common.component-card :title="$title">
        <form method="POST" action="{{ $vehicle->exists ? route('vehicles.update', $vehicle) : route('vehicles.store') }}" class="space-y-5">
            @csrf
            @if ($vehicle->exists) @method('PUT') @endif

            <x-form.input name="make_model" label="Make & Model" placeholder="White Swift Dzire" value="{{ old('make_model', $vehicle->make_model) }}" required />

            <x-form.input name="plate_number" label="Plate Number" placeholder="BR01PA1234" value="{{ old('plate_number', $vehicle->plate_number) }}" required />

            <x-form.select name="vehicle_category_id" label="Category" required>
                <option value="">Select category</option>
                @foreach ($categories as $category)
                    <option value="{{ $category->id }}" @selected(old('vehicle_category_id', $vehicle->vehicle_category_id) == $category->id)>{{ $category->name }}</option>
                @endforeach
            </x-form.select>

            <x-form.select name="driver_id" label="Driver">
                <option value="">— unassigned —</option>
                @foreach ($drivers as $driver)
                    <option value="{{ $driver->id }}" @selected(old('driver_id', $vehicle->driver_id) == $driver->id)>{{ $driver->name }}</option>
                @endforeach
            </x-form.select>

            <x-form.input name="color" label="Color" value="{{ old('color', $vehicle->color) }}" />

            <div class="flex items-center gap-6">
                <x-form.checkbox name="non_smoking" :checked="old('non_smoking', $vehicle->exists ? $vehicle->non_smoking : true)">Non-smoking</x-form.checkbox>
                <x-form.checkbox name="gps_enabled" :checked="old('gps_enabled', $vehicle->exists ? $vehicle->gps_enabled : true)">GPS enabled</x-form.checkbox>
            </div>

            <x-ui.button type="submit">Save Vehicle</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
