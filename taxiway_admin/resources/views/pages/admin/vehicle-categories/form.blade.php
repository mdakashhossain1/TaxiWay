@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$title" />

    <x-common.back-link :href="route('vehicle-categories.index')" label="Back to Vehicle Categories" />

    <x-common.component-card :title="$title">
        <form method="POST" action="{{ $category->exists ? route('vehicle-categories.update', $category) : route('vehicle-categories.store') }}" class="space-y-5">
            @csrf
            @if ($category->exists) @method('PUT') @endif

            <x-form.input name="name" label="Name" placeholder="Sedan" value="{{ old('name', $category->name) }}" required />

            <x-form.input type="number" name="seats" label="Seats" min="1" value="{{ old('seats', $category->seats) }}" required />

            <x-form.input type="number" name="base_fare" label="Base Fare (₹)" step="0.01" min="0" value="{{ old('base_fare', $category->base_fare) }}" required />

            <x-form.input type="number" name="per_km_rate" label="Per KM Rate (₹)" step="0.01" min="0" value="{{ old('per_km_rate', $category->per_km_rate) }}" required />

            <x-form.input type="number" name="per_min_rate" label="Per Minute Rate (₹)" step="0.01" min="0" value="{{ old('per_min_rate', $category->per_min_rate) }}" required />

            <x-form.checkbox name="ac" :checked="old('ac', $category->exists ? $category->ac : true)">Air Conditioned</x-form.checkbox>

            <x-ui.button type="submit">Save Category</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
