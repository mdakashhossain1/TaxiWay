@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb :pageTitle="$driver->name" />

    <x-common.back-link :href="route('drivers.index')" label="Back to Drivers" />


    <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <div class="lg:col-span-2 space-y-6">
            <x-common.component-card title="Driver Details">
                <dl class="grid grid-cols-2 gap-4 text-sm">
                    <div><dt class="text-gray-500 dark:text-gray-400">Phone</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $driver->phone }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Rating</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $driver->rating }} ({{ $driver->total_trips }} trips)</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Operating Area</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $driver->operating_area ?? '—' }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Experience</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ $driver->years_experience }} yrs</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Languages</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ collect($driver->languages)->join(', ') ?: '—' }}</dd></div>
                    <div><dt class="text-gray-500 dark:text-gray-400">Member Since</dt><dd class="font-medium text-gray-800 dark:text-white/90">{{ optional($driver->member_since)->format('d M Y') }}</dd></div>
                </dl>
                <div class="mt-4">
                    <a href="{{ route('drivers.edit', $driver) }}" class="text-brand-500 hover:text-brand-600 text-theme-sm font-medium">Edit details</a>
                </div>
            </x-common.component-card>

            <x-common.component-card title="Vehicles">
                @forelse ($driver->vehicles as $vehicle)
                    <div class="flex items-center justify-between border-b border-gray-100 py-3 last:border-0 dark:border-gray-800">
                        <div>
                            <p class="font-medium text-gray-800 dark:text-white/90">{{ $vehicle->make_model }} — {{ $vehicle->plate_number }}</p>
                            <p class="text-sm text-gray-500 dark:text-gray-400">{{ $vehicle->category->name }}</p>
                        </div>
                        <a href="{{ route('vehicles.edit', $vehicle) }}" class="text-brand-500 hover:text-brand-600 text-theme-sm font-medium">Edit</a>
                    </div>
                @empty
                    <p class="text-sm text-gray-500 dark:text-gray-400">No vehicle assigned yet.</p>
                @endforelse
                <div class="mt-3">
                    <a href="{{ route('vehicles.create') }}?driver_id={{ $driver->id }}" class="text-brand-500 hover:text-brand-600 text-theme-sm font-medium">+ Assign a vehicle</a>
                </div>
            </x-common.component-card>

            <x-common.component-card title="KYC Documents">
                <p class="mb-4 text-theme-sm text-gray-500 dark:text-gray-400">
                    Optional — store scanned copies of the documents checked during offline verification. Verifying a driver does not require any document to be uploaded here.
                </p>

                @forelse ($driver->documents as $document)
                    <div class="flex items-center justify-between border-b border-gray-100 py-3 last:border-0 dark:border-gray-800">
                        <div>
                            <p class="font-medium text-gray-800 dark:text-white/90">{{ $document->label }}</p>
                            <p class="text-sm text-gray-500 dark:text-gray-400">{{ $document->original_name }} · {{ $document->created_at->format('d M Y') }}</p>
                        </div>
                        <div class="flex items-center gap-3">
                            <a href="{{ route('drivers.documents.download', [$driver, $document]) }}" class="text-brand-500 hover:text-brand-600 text-theme-sm font-medium">Download</a>
                            <form id="delete-document-{{ $document->id }}" method="POST" action="{{ route('drivers.documents.destroy', [$driver, $document]) }}">
                                @csrf
                                @method('DELETE')
                            </form>
                            <button
                                type="button"
                                class="text-theme-sm font-medium text-error-500 hover:text-error-600"
                                @click="$store.confirm.ask('Remove {{ addslashes($document->label) }}?', 'This cannot be undone.', () => document.getElementById('delete-document-{{ $document->id }}').requestSubmit())"
                            >Remove</button>
                        </div>
                    </div>
                @empty
                    <p class="text-sm text-gray-500 dark:text-gray-400">No documents uploaded yet.</p>
                @endforelse

                <form method="POST" action="{{ route('drivers.documents.store', $driver) }}" enctype="multipart/form-data" class="mt-4 flex flex-col gap-3 sm:flex-row sm:items-end">
                    @csrf
                    <div class="flex-1">
                        <x-form.input name="label" label="Label" placeholder="e.g. Driving License" />
                    </div>
                    <div class="flex-1">
                        <x-form.file name="file" label="File" />
                    </div>
                    <x-ui.button type="submit" size="sm">Upload</x-ui.button>
                </form>
            </x-common.component-card>

            <x-common.component-card title="Recent Bookings">
                @forelse ($driver->bookings as $booking)
                    <div class="flex items-center justify-between border-b border-gray-100 py-3 last:border-0 dark:border-gray-800">
                        <div>
                            <p class="font-medium text-gray-800 dark:text-white/90">{{ $booking->pickup_address }} → {{ $booking->destination_address }}</p>
                            <p class="text-sm text-gray-500 dark:text-gray-400">₹{{ $booking->total_fare }} · {{ $booking->created_at->format('d M, h:i A') }}</p>
                        </div>
                        <x-ui.badge :color="$booking->status === 'completed' ? 'success' : ($booking->status === 'cancelled' ? 'error' : 'warning')">{{ $booking->status }}</x-ui.badge>
                    </div>
                @empty
                    <p class="text-sm text-gray-500 dark:text-gray-400">No bookings yet.</p>
                @endforelse
            </x-common.component-card>
        </div>

        <div class="space-y-6">
            <x-common.component-card title="Verification">
                <x-ui.badge :color="$driver->verification_status === 'verified' ? 'success' : ($driver->verification_status === 'suspended' ? 'error' : 'warning')" size="md">
                    {{ $driver->verification_status }}
                </x-ui.badge>

                <div class="mt-4 space-y-2">
                    @if ($driver->verification_status !== 'verified')
                        <form method="POST" action="{{ route('drivers.verify', $driver) }}">
                            @csrf
                            <x-ui.button type="submit" className="w-full">Verify Driver</x-ui.button>
                        </form>
                    @endif
                    @if ($driver->verification_status !== 'suspended')
                        <form method="POST" action="{{ route('drivers.suspend', $driver) }}">
                            @csrf
                            <x-ui.button type="submit" variant="outline" className="w-full">Suspend Driver</x-ui.button>
                        </form>
                    @endif
                </div>
            </x-common.component-card>

            @if ($driver->subscription)
                <x-common.component-card title="Subscription">
                    <p class="text-sm text-gray-500 dark:text-gray-400">{{ $driver->subscription->plan->name }} · ₹{{ $driver->subscription->plan->price_per_month }}/mo</p>
                    <p class="mt-2 text-lg font-semibold text-gray-800 dark:text-white/90">{{ $driver->subscription->rides_used }} / {{ $driver->subscription->plan->rides_included }} rides used</p>
                    <p class="text-sm text-gray-500 dark:text-gray-400">Renews {{ $driver->subscription->renewal_date->format('d M Y') }}</p>
                    <a href="{{ route('driver-subscriptions.show', $driver->subscription) }}" class="mt-3 inline-block text-brand-500 hover:text-brand-600 text-theme-sm font-medium">View full history</a>
                </x-common.component-card>
            @endif
        </div>
    </div>
@endsection
