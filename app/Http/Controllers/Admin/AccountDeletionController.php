<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AccountDeletionRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AccountDeletionController extends Controller
{
    public function index(Request $request): View
    {
        $query = AccountDeletionRequest::latest();

        if ($q = $request->query('q')) {
            $query->where(fn ($w) => $w->where('name', 'like', "%{$q}%")
                ->orWhere('phone', 'like', "%{$q}%")
                ->orWhere('email', 'like', "%{$q}%")
                ->orWhere('reason', 'like', "%{$q}%"));
        }

        $requests = $query->paginate(15)->withQueryString();

        return view('pages.admin.account-deletions.index', ['title' => 'Account Deletions', 'requests' => $requests]);
    }

    public function bulkDestroy(Request $request): RedirectResponse
    {
        $ids = $request->validate(['ids' => ['required', 'array'], 'ids.*' => ['integer']])['ids'];
        $count = AccountDeletionRequest::whereIn('id', $ids)->delete();

        return redirect()->route('account-deletions.index')->with('status', "{$count} record(s) removed.");
    }
}
