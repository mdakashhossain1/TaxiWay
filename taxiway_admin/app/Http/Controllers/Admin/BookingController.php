<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class BookingController extends Controller
{
    /** Kept in sync with the enum in the bookings table migration. */
    private const STATUSES = [
        'requested', 'allocating', 'driver_offered', 'driver_assigned', 'driver_en_route',
        'driver_arrived', 'ride_started', 'ride_in_progress', 'completed', 'cancelled', 'failed',
    ];

    public function index(Request $request): View
    {
        $query = Booking::with(['customer', 'driver', 'category'])->latest();

        if ($status = $request->query('status')) {
            $query->where('status', $status);
        }

        if ($q = $request->query('q')) {
            $query->where(fn ($w) => $w->where('pickup_address', 'like', "%{$q}%")
                ->orWhere('destination_address', 'like', "%{$q}%")
                ->orWhereHas('customer', fn ($c) => $c->where('name', 'like', "%{$q}%")));
        }

        return view('pages.admin.bookings.index', [
            'title' => 'Bookings',
            'bookings' => $query->paginate(15)->withQueryString(),
            'currentStatus' => $status ?? '',
            'statuses' => self::STATUSES,
        ]);
    }

    public function show(Booking $booking): View
    {
        $booking->load(['customer', 'driver', 'vehicle', 'category', 'review']);

        return view('pages.admin.bookings.show', ['title' => "Booking #{$booking->id}", 'booking' => $booking, 'statuses' => self::STATUSES]);
    }

    public function updateStatus(Request $request, Booking $booking): RedirectResponse
    {
        $data = $request->validate(['status' => ['required', 'in:'.implode(',', self::STATUSES)]]);

        $booking->update($data);

        return back()->with('status', "Booking #{$booking->id} marked as {$data['status']}.");
    }

    public function destroy(Booking $booking): RedirectResponse
    {
        $booking->delete();

        return redirect()->route('bookings.index')->with('status', 'Booking removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = Booking::whereIn('id', $ids)->delete();

        return redirect()->route('bookings.index')->with('status', "{$count} booking(s) removed.");
    }
}
