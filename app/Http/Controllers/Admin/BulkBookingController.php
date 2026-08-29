<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\BulkBooking;
use Illuminate\View\View;

class BulkBookingController extends Controller
{
    public function show(BulkBooking $bulkBooking): View
    {
        $bulkBooking->load(['customer', 'offers.driver', 'offers.vehicle']);

        return view('pages.admin.bulk-bookings.show', [
            'title' => "Bulk Booking #{$bulkBooking->id}",
            'bulkBooking' => $bulkBooking,
        ]);
    }
}
