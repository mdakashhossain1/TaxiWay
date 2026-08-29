<?php

namespace App\View\Components\Dashboard;

use Closure;
use Illuminate\Contracts\View\View;
use Illuminate\View\Component;

class Metrics extends Component
{
    public function __construct(
        public int $customersCount = 0,
        public int $driversCount = 0,
        public int $bookingsCount = 0,
        public float $totalRevenue = 0,
    ) {
        //
    }

    public function render(): View|Closure|string
    {
        return view('components.dashboard.metrics');
    }
}
