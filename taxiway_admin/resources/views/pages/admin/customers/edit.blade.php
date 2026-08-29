@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Edit Customer" />

    <x-common.back-link :href="route('customers.index')" label="Back to Customers" />

    <x-common.component-card title="Edit {{ $customer->name }}">
        <form method="POST" action="{{ route('customers.update', $customer) }}" class="space-y-5">
            @csrf
            @method('PUT')

            <x-form.input name="name" label="Full Name" value="{{ old('name', $customer->name) }}" required />

            <x-form.input name="phone" label="Phone (10 digits)" value="{{ old('phone', $customer->phone) }}" maxlength="10" />

            <x-form.input type="email" name="email" label="Email" value="{{ old('email', $customer->email) }}" />

            <x-ui.button type="submit">Save Changes</x-ui.button>
        </form>
    </x-common.component-card>
@endsection
