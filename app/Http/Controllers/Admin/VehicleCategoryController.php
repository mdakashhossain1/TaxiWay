<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\VehicleCategory;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
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
        $data = $this->validated($request);

        if ($request->hasFile('image')) {
            $data['image_path'] = $request->file('image')->store('vehicle-categories', 'public');
        }

        VehicleCategory::create($data);

        return redirect()->route('vehicle-categories.index')->with('status', 'Category created.');
    }

    public function edit(VehicleCategory $vehicleCategory): View
    {
        return view('pages.admin.vehicle-categories.form', ['title' => 'Edit Category', 'category' => $vehicleCategory]);
    }

    public function update(Request $request, VehicleCategory $vehicleCategory): RedirectResponse
    {
        $data = $this->validated($request);

        if ($request->hasFile('image')) {
            $oldPath = $vehicleCategory->image_path;
            $data['image_path'] = $request->file('image')->store('vehicle-categories', 'public');
            if ($oldPath) {
                Storage::disk('public')->delete($oldPath);
            }
        }

        $vehicleCategory->update($data);

        return redirect()->route('vehicle-categories.index')->with('status', 'Pricing updated — customer apps will see the new fare immediately.');
    }

    public function destroy(VehicleCategory $vehicleCategory): RedirectResponse
    {
        if ($vehicleCategory->image_path) {
            Storage::disk('public')->delete($vehicleCategory->image_path);
        }

        $vehicleCategory->delete();

        return redirect()->route('vehicle-categories.index')->with('status', 'Category removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];

        VehicleCategory::whereIn('id', $ids)->pluck('image_path')->filter()->each(
            fn (string $path) => Storage::disk('public')->delete($path)
        );

        $count = VehicleCategory::whereIn('id', $ids)->delete();
        $label = $count === 1 ? 'category' : 'categories';

        return redirect()->route('vehicle-categories.index')->with('status', "{$count} {$label} removed.");
    }

    private function validated(Request $request): array
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:1000'],
            'translations' => ['nullable', 'array'],
            'translations.*.name' => ['nullable', 'string', 'max:255'],
            'translations.*.description' => ['nullable', 'string', 'max:1000'],
            'image' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:2048'],
            'seats' => ['required', 'integer', 'min:1', 'max:50'],
            'base_fare' => ['required', 'numeric', 'min:0'],
            'per_km_rate' => ['required', 'numeric', 'min:0'],
            'per_min_rate' => ['required', 'numeric', 'min:0'],
        ]);

        unset($data['image']);

        $data['ac'] = $request->boolean('ac');

        $translations = [];
        foreach (VehicleCategory::SUPPORTED_LOCALES as $locale => $label) {
            if ($locale === 'en') {
                continue;
            }

            $name = trim($data['translations'][$locale]['name'] ?? '');
            $description = trim($data['translations'][$locale]['description'] ?? '');

            if ($name !== '' || $description !== '') {
                $translations[$locale] = array_filter([
                    'name' => $name !== '' ? $name : null,
                    'description' => $description !== '' ? $description : null,
                ]);
            }
        }
        $data['translations'] = $translations ?: null;

        return $data;
    }
}
