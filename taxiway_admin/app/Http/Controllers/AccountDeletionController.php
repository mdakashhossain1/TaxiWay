<?php

namespace App\Http\Controllers;

use App\Mail\AccountDeletedMail;
use App\Models\AccountDeletionRequest;
use App\Models\Customer;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\View\View;

/**
 * Public, unauthenticated account-deletion page (linked from the taxiway
 * app's profile menu). Deliberately has no OTP/login step — identity is
 * checked by requiring the phone number on the account plus, when the
 * account already has an email on file, a matching email. This is weaker
 * than session-based auth by design (per product decision), so the
 * destroy route is throttled to slow down guessing.
 */
class AccountDeletionController extends Controller
{
    public function show(): View
    {
        return view('pages.account-delete');
    }

    public function destroy(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
            'email' => ['required', 'email', 'max:255'],
            'reason' => ['required', 'string', 'min:5', 'max:1000'],
        ]);

        $customer = Customer::where('phone', $data['phone'])->first();

        if (! $customer) {
            return back()->withInput()->withErrors(['phone' => 'No account was found with that phone number.']);
        }

        if ($customer->email && strcasecmp($customer->email, $data['email']) !== 0) {
            return back()->withInput()->withErrors(['email' => "That email doesn't match the one on this account."]);
        }

        $name = $customer->name;

        AccountDeletionRequest::create([
            'name' => $name,
            'phone' => $customer->phone,
            'email' => $data['email'],
            'reason' => $data['reason'],
        ]);

        // Bookings, bulk bookings, reviews, and support tickets all cascade-delete
        // via their customer_id foreign key; tokens don't, so drop those explicitly.
        $customer->tokens()->delete();
        $customer->delete();

        Mail::to($data['email'])->queue(new AccountDeletedMail($name));

        return redirect()->route('account.delete.form')->with('account_deleted', true);
    }
}
