<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Driver;
use App\Models\Vehicle;
use App\Models\VehicleCategory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class VehicleController extends Controller
{
    public function index(Request $request): View
    {
        $query = Vehicle::with(['driver', 'category'])->latest();

        if ($q = $request->query('q')) {
            $query->where(fn ($w) => $w->where('make_model', 'like', "%{$q}%")->orWhere('plate_number', 'like', "%{$q}%"));
        }

        if ($categoryId = $request->query('category')) {
            $query->where('vehicle_category_id', $categoryId);
        }

        $vehicles = $query->paginate(15)->withQueryString();

        return view('pages.admin.vehicles.index', [
            'title' => 'Vehicles',
            'vehicles' => $vehicles,
            'categories' => VehicleCategory::orderBy('name')->get(),
            'currentCategory' => $categoryId ?? '',
        ]);
    }

    public function create(Request $request): View
    {
        return view('pages.admin.vehicles.form', [
            'title' => 'Add Vehicle',
            'vehicle' => new Vehicle(['driver_id' => $request->query('driver_id')]),
            'drivers' => Driver::orderBy('name')->get(),
            'categories' => VehicleCategory::orderBy('name')->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $this->validated($request);
        $vehicle = Vehicle::create($data);

        return redirect()->route('vehicles.index')->with('status', "{$vehicle->make_model} added.");
    }

    public function show(Vehicle $vehicle): RedirectResponse
    {
        return redirect()->route('vehicles.edit', $vehicle);
    }

    public function edit(Vehicle $vehicle): View
    {
        return view('pages.admin.vehicles.form', [
            'title' => 'Edit Vehicle',
            'vehicle' => $vehicle,
            'drivers' => Driver::orderBy('name')->get(),
            'categories' => VehicleCategory::orderBy('name')->get(),
        ]);
    }

    public function update(Request $request, Vehicle $vehicle): RedirectResponse
    {
        $vehicle->update($this->validated($request, $vehicle->id));

        return redirect()->route('vehicles.index')->with('status', 'Vehicle updated.');
    }

    public function destroy(Vehicle $vehicle): RedirectResponse
    {
        $vehicle->delete();

        return redirect()->route('vehicles.index')->with('status', 'Vehicle removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = Vehicle::whereIn('id', $ids)->delete();

        return redirect()->route('vehicles.index')->with('status', "{$count} vehicle(s) removed.");
    }

    private function validated(Request $request, ?int $ignoreId = null): array
    {
        $data = $request->validate([
            'driver_id' => ['nullable', 'exists:drivers,id'],
            'vehicle_category_id' => ['required', 'exists:vehicle_categories,id'],
            'make_model' => ['required', 'string', 'max:255'],
            'plate_number' => ['required', 'string', 'max:20', 'unique:vehicles,plate_number,'.$ignoreId],
            'color' => ['nullable', 'string', 'max:50'],
            'fuel_type' => ['nullable', 'string', 'max:50'],
        ]);

        $data['non_smoking'] = $request->boolean('non_smoking');
        $data['gps_enabled'] = $request->boolean('gps_enabled');

        return $data;
    }
}
