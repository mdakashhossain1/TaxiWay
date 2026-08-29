<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class CustomerController extends Controller
{
    public function index(Request $request): View
    {
        $query = Customer::withCount('bookings')->latest();

        if ($q = $request->query('q')) {
            $query->where(fn ($w) => $w->where('name', 'like', "%{$q}%")
                ->orWhere('phone', 'like', "%{$q}%")
                ->orWhere('email', 'like', "%{$q}%"));
        }

        $customers = $query->paginate(15)->withQueryString();

        return view('pages.admin.customers.index', ['title' => 'Customers', 'customers' => $customers]);
    }

    public function show(Customer $customer): View
    {
        $customer->load(['bookings' => fn ($q) => $q->latest()->limit(20), 'bookings.driver']);

        return view('pages.admin.customers.show', ['title' => $customer->name, 'customer' => $customer]);
    }

    public function edit(Customer $customer): View
    {
        return view('pages.admin.customers.edit', ['title' => 'Edit Customer', 'customer' => $customer]);
    }

    public function update(Request $request, Customer $customer): RedirectResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'phone' => ['nullable', 'digits:10', 'unique:customers,phone,'.$customer->id],
            'email' => ['nullable', 'email', 'max:255', 'unique:customers,email,'.$customer->id],
        ]);

        $customer->update($data);

        return redirect()->route('customers.show', $customer)->with('status', 'Customer updated.');
    }

    public function destroy(Customer $customer): RedirectResponse
    {
        $customer->delete();

        return redirect()->route('customers.index')->with('status', 'Customer removed.');
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = Customer::whereIn('id', $ids)->delete();

        return redirect()->route('customers.index')->with('status', "{$count} customer(s) removed.");
    }
}
