<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Booking;
use App\Models\BulkBooking;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Str;
use Illuminate\View\View;

class CalendarController extends Controller
{
    private const BOOKING_COLOR = [
        'completed' => 'Success',
        'cancelled' => 'Danger',
        'failed' => 'Danger',
        'driver_assigned' => 'Warning',
        'driver_en_route' => 'Warning',
        'driver_arrived' => 'Warning',
        'ride_started' => 'Warning',
        'ride_in_progress' => 'Warning',
    ];

    private const BULK_COLOR = [
        'confirmed' => 'Success',
        'cancelled' => 'Danger',
        'offer_ready' => 'Warning',
    ];

    public function index(Request $request): View
    {
        $month = Carbon::createFromFormat('Y-m', $request->query('month', now()->format('Y-m')))->startOfMonth();
        $monthStart = $month->copy()->startOfMonth();
        $monthEnd = $month->copy()->endOfMonth();

        $bookings = Booking::with(['customer', 'driver'])
            ->whereBetween('created_at', [$monthStart, $monthEnd])
            ->get();

        $bulkBookings = BulkBooking::with(['customer', 'offers.driver'])
            ->whereBetween('travel_date', [$monthStart, $monthEnd])
            ->get();

        $events = $bookings->map(function (Booking $booking) {
            return [
                'id' => 'booking-'.$booking->id,
                'title' => "{$booking->customer->name} → ".Str::limit($booking->destination_address, 24),
                'start' => $booking->created_at->toDateString(),
                'url' => route('bookings.show', $booking),
                'extendedProps' => [
                    'calendar' => self::BOOKING_COLOR[$booking->status] ?? 'Primary',
                    'type' => 'Booking',
                    'status' => str_replace('_', ' ', $booking->status),
                    'driver' => $booking->driver?->name,
                ],
            ];
        })->values();

        $bulkEvents = $bulkBookings->map(function (BulkBooking $bulkBooking) {
            $assignedDriver = $bulkBooking->status === 'confirmed' && $bulkBooking->offers->count() === 1
                ? $bulkBooking->offers->first()->driver?->name
                : null;

            return [
                'id' => 'bulk-'.$bulkBooking->id,
                'title' => 'Bulk: '.Str::limit($bulkBooking->from_location, 12).' → '.Str::limit($bulkBooking->to_location, 12),
                'start' => $bulkBooking->travel_date->toDateString(),
                'url' => route('bulk-bookings.show', $bulkBooking),
                'extendedProps' => [
                    'calendar' => self::BULK_COLOR[$bulkBooking->status] ?? 'Primary',
                    'type' => 'Bulk booking',
                    'status' => str_replace('_', ' ', $bulkBooking->status),
                    'driver' => $assignedDriver,
                    'offerCount' => $bulkBooking->offers->count(),
                ],
            ];
        })->values();

        $bookingsTotal = $bookings->count();
        $bookingsCompleted = $bookings->where('status', 'completed')->count();

        $bulkTotal = $bulkBookings->count();
        $bulkConfirmed = $bulkBookings->where('status', 'confirmed')->count();

        return view('pages.calender', [
            'title' => 'Calendar',
            'events' => $events->merge($bulkEvents)->values(),
            'currentMonth' => $month->format('Y-m'),
            'monthLabel' => $month->format('F Y'),
            'prevMonth' => $month->copy()->subMonth()->format('Y-m'),
            'nextMonth' => $month->copy()->addMonth()->format('Y-m'),
            'bookingsTotal' => $bookingsTotal,
            'bookingsCompleted' => $bookingsCompleted,
            'bulkTotal' => $bulkTotal,
            'bulkConfirmed' => $bulkConfirmed,
        ]);
    }
}
