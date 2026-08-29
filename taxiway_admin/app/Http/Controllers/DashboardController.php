<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\Customer;
use App\Models\Driver;
use Illuminate\Support\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $rangeStart = now()->subDays(29)->startOfDay();
        $days = collect(range(0, 29))->map(fn ($i) => $rangeStart->copy()->addDays($i)->toDateString());

        $recentBookings30d = Booking::where('created_at', '>=', $rangeStart)
            ->with('category:id,name')
            ->get(['id', 'created_at', 'status', 'total_fare', 'vehicle_category_id']);

        $byDate = $recentBookings30d->groupBy(fn (Booking $b) => $b->created_at->toDateString());

        $bookingsTrend = $days->map(fn ($date) => $byDate->get($date, collect())->count());
        $revenueTrend = $days->map(fn ($date) => (float) $byDate->get($date, collect())
            ->where('status', 'completed')
            ->sum('total_fare'));

        $statusBreakdown = $recentBookings30d->countBy(fn (Booking $b) => str_replace('_', ' ', $b->status));

        $categoryBreakdown = $recentBookings30d
            ->countBy(fn (Booking $b) => $b->category->name ?? 'Unknown');

        return view('pages.dashboard.index', [
            'title' => 'Dashboard',
            'customersCount' => Customer::count(),
            'driversCount' => Driver::count(),
            'bookingsCount' => Booking::count(),
            'totalRevenue' => (float) Booking::where('status', 'completed')->sum('total_fare'),
            'recentBookings' => Booking::with('customer')->latest()->limit(8)->get(),
            'chartLabels' => $days->map(fn ($date) => Carbon::parse($date)->format('d M'))->values(),
            'bookingsTrend' => $bookingsTrend->values(),
            'revenueTrend' => $revenueTrend->values(),
            'statusLabels' => $statusBreakdown->keys()->values(),
            'statusCounts' => $statusBreakdown->values()->values(),
            'categoryLabels' => $categoryBreakdown->keys()->values(),
            'categoryCounts' => $categoryBreakdown->values()->values(),
        ]);
    }
}
