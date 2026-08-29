<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\VehicleCategory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class VehicleCategoryController extends Controller
{
    public function index(Request $request): View
    {
        $query = VehicleCategory::withCount('vehicles')->orderBy('base_fare');

        if ($q = $request->query('q')) {
            $query->where('name', 'like', "%{$q}%");
        }

        $categories = $query->paginate(15)->withQueryString();

        return view('pages.admin.vehicle-categories.index', ['title' => 'Vehicle Categories & Pricing', 'categories' => $categories]);
    }

    public function create(): View
    {
        return view('pages.admin.vehicle-categories.form', ['title' => 'Add Category', 'category' => new VehicleCategory]);
    }

    public function store(Request $request): RedirectResponse
    {
        VehicleCategory::create($this->validated($request));

        return redirect()->route('vehicle-categories.index')->with('status', 'Category created.');
    }

    public function edit(VehicleCategory $vehicleCategory): View
    {
        return view('pages.admin.vehicle-categories.form', ['title' => 'Edit Category', 'category' => $vehicleCategory]);
    }

    public function update(Request $request, VehicleCategory $vehicleCategory): RedirectResponse
    {
        $vehicleCategory->update($this->validated($request));

        return redirect()->route('vehicle-categories.index')->with('status', 'Pricing updated — customer apps will see the new fare immediately.');
    }

    public function destroy(VehicleCategory $vehicleCategory): RedirectResponse
    {
        $vehicleCategory->delete();

        return redirect()->route('vehicle-categories.index')->with('status', 'Category removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = VehicleCategory::whereIn('id', $ids)->delete();
        $label = $count === 1 ? 'category' : 'categories';

        return redirect()->route('vehicle-categories.index')->with('status', "{$count} {$label} removed.");
    }

    private function validated(Request $request): array
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'seats' => ['required', 'integer', 'min:1', 'max:50'],
            'base_fare' => ['required', 'numeric', 'min:0'],
            'per_km_rate' => ['required', 'numeric', 'min:0'],
            'per_min_rate' => ['required', 'numeric', 'min:0'],
        ]);

        $data['ac'] = $request->boolean('ac');

        return $data;
    }
}
