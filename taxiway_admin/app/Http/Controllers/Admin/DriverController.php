<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Mail\DriverVerifiedMail;
use App\Models\Driver;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\View\View;

class DriverController extends Controller
{
    public function index(Request $request): View
    {
        $query = Driver::withCount('vehicles')->latest();

        if ($q = $request->query('q')) {
            $query->where(fn ($w) => $w->where('name', 'like', "%{$q}%")->orWhere('phone', 'like', "%{$q}%"));
        }

        if ($status = $request->query('status')) {
            $query->where('verification_status', $status);
        }

        $drivers = $query->paginate(15)->withQueryString();

        return view('pages.admin.drivers.index', ['title' => 'Drivers', 'drivers' => $drivers, 'currentStatus' => $status ?? '']);
    }

    public function create(): View
    {
        return view('pages.admin.drivers.create', ['title' => 'Add Driver']);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'phone' => ['required', 'digits:10', 'unique:drivers,phone'],
            'operating_area' => ['nullable', 'string', 'max:255'],
            'years_experience' => ['nullable', 'integer', 'min:0'],
        ]);

        $driver = Driver::create([
            ...$data,
            'member_since' => now(),
            'verification_status' => 'pending',
        ]);

        return redirect()->route('drivers.show', $driver)->with('status', 'Driver added — pending verification.');
    }

    public function show(Driver $driver): View
    {
        $driver->load(['vehicles.category', 'subscription.plan', 'documents', 'bookings' => fn ($q) => $q->latest()->limit(10)]);

        return view('pages.admin.drivers.show', ['title' => $driver->name, 'driver' => $driver]);
    }

    public function edit(Driver $driver): View
    {
        return view('pages.admin.drivers.edit', ['title' => 'Edit Driver', 'driver' => $driver]);
    }

    public function update(Request $request, Driver $driver): RedirectResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'phone' => ['required', 'digits:10', 'unique:drivers,phone,'.$driver->id],
            'operating_area' => ['nullable', 'string', 'max:255'],
            'years_experience' => ['nullable', 'integer', 'min:0'],
            'languages' => ['nullable', 'string'],
        ]);

        $languages = $data['languages'] ?? '';
        unset($data['languages']);

        $driver->update([
            ...$data,
            'languages' => $languages !== '' ? array_map('trim', explode(',', $languages)) : [],
        ]);

        return redirect()->route('drivers.show', $driver)->with('status', 'Driver updated.');
    }

    public function destroy(Driver $driver): RedirectResponse
    {
        $driver->delete();

        return redirect()->route('drivers.index')->with('status', 'Driver removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = Driver::whereIn('id', $ids)->delete();

        return redirect()->route('drivers.index')->with('status', "{$count} driver(s) removed.");
    }

    /**
     * The actual "ops activates the driver after offline verification"
     * step from the PRD — nothing else in this system can flip this flag.
     */
    public function verify(Driver $driver): RedirectResponse
    {
        $driver->update([
            'verification_status' => 'verified',
            'identity_verified' => true,
            'licence_verified' => true,
            'background_checked' => true,
        ]);

        $status = "{$driver->name} is now verified and can go online to receive rides.";

        if ($driver->email) {
            try {
                // Queued (DriverVerifiedMail implements ShouldQueue) — this only
                // catches failures to enqueue the job, not delivery failures.
                // Actual send failures land in the failed_jobs table instead,
                // once something processes the queue (see routes/console.php).
                Mail::to($driver->email)->queue(new DriverVerifiedMail($driver));
                $status .= ' Notification email queued.';
            } catch (\Throwable $e) {
                Log::warning("Failed to queue verification email to driver {$driver->id}: {$e->getMessage()}");
                $status .= ' (Notification email could not be queued — check mail settings.)';
            }
        } else {
            $status .= ' No email on file, so no notification was sent.';
        }

        return back()->with('status', $status);
    }

    public function suspend(Driver $driver): RedirectResponse
    {
        $driver->update(['verification_status' => 'suspended']);

        return back()->with('status', "{$driver->name} has been suspended.");
    }
}
