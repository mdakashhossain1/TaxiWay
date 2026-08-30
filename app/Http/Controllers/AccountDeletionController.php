<?php

namespace App\Http\Controllers;

use App\Mail\AccountDeletedMail;
use App\Mail\ConfirmAccountDeletionMail;
use App\Models\AccountDeletionRequest;
use App\Models\Booking;
use App\Models\Customer;
use App\Support\AccountDeletionCopy;
use App\Support\Locale;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\URL;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

/**
 * Public, unauthenticated account-deletion page (linked from the taxiway
 * app's profile menu). Deliberately has no OTP/login step.
 *
 * Identity is checked by phone number plus, when the account already has
 * an email on file, a matching email — that combination is treated as
 * strong enough to delete immediately. Most customers sign up via phone
 * OTP and never set an email, though, so for those accounts a phone
 * number alone (not a secret) would otherwise be enough to delete
 * someone else's account. To close that gap, accounts without an email
 * on file go through a signed, time-limited confirmation link emailed to
 * the address the requester typed in — still a single click, not a
 * login/OTP flow, but the deletion can't fire without the requester
 * actually controlling an inbox.
 *
 * The page and its emails follow the taxiway app's language, not the
 * browser's: the app already knows which of en/hi/bn the customer picked,
 * so it appends `?lang=` when opening this page. That choice is kept in
 * the session for the rest of the flow and stamped onto the
 * AccountDeletionRequest row so the confirmation email (sent now) and the
 * final "deleted" email (sent whenever the link is eventually clicked,
 * possibly on a different device) both stay in the same language.
 */
class AccountDeletionController extends Controller
{
    private const SESSION_KEY = 'account_delete_locale';

    public function show(Request $request): View
    {
        $locale = $this->resolveLocale($request);

        return view('pages.account-delete', [
            'locale' => $locale,
            't' => AccountDeletionCopy::text($locale),
        ]);
    }

    public function destroy(Request $request): RedirectResponse
    {
        $locale = $this->resolveLocale($request);
        $t = AccountDeletionCopy::text($locale);

        $data = $request->validate([
            'phone' => ['required', 'digits:10'],
            'email' => ['required', 'email', 'max:255'],
            'reason_option' => ['required', Rule::in([...AccountDeletionCopy::reasonOptionKeys(), 'other'])],
            'reason_other' => ['required_if:reason_option,other', 'nullable', 'string', 'min:5', 'max:1000'],
        ], [
            'phone.required' => $t['validation_phone_required'],
            'phone.digits' => $t['validation_phone_digits'],
            'email.required' => $t['validation_email_required'],
            'email.email' => $t['validation_email_invalid'],
            'reason_option.required' => $t['validation_reason_option_required'],
            'reason_other.required_if' => $t['validation_reason_required'],
            'reason_other.min' => $t['validation_reason_min'],
        ]);

        $reason = $data['reason_option'] === 'other'
            ? $data['reason_other']
            : AccountDeletionCopy::canonicalReason($data['reason_option']);

        $customer = Customer::where('phone', $data['phone'])->first();

        if (! $customer) {
            return back()->withInput()->withErrors(['phone' => $t['error_no_account']]);
        }

        if ($this->hasActiveBooking($customer)) {
            return back()->withInput()->withErrors(['phone' => $t['error_active_booking']]);
        }

        if ($customer->email) {
            if (strcasecmp($customer->email, $data['email']) !== 0) {
                return back()->withInput()->withErrors(['email' => $t['error_email_mismatch']]);
            }

            $this->deleteCustomer($customer, $data['email'], $locale, $reason);

            return redirect()->route('account.delete.form')->with('account_deleted', true);
        }

        // No email on file — can't cross-check, so require a confirmation click first.
        $pending = AccountDeletionRequest::create([
            'customer_id' => $customer->id,
            'name' => $customer->name,
            'phone' => $customer->phone,
            'email' => $data['email'],
            'reason' => $reason,
            'locale' => $locale,
        ]);

        $confirmUrl = URL::temporarySignedRoute(
            'account.delete.confirm',
            now()->addHours(24),
            ['accountDeletionRequest' => $pending->id]
        );

        Mail::to($data['email'])->queue(new ConfirmAccountDeletionMail($customer->name, $confirmUrl, $locale));

        return redirect()->route('account.delete.form')->with('confirmation_sent', true);
    }

    /** Reached via the signed link in ConfirmAccountDeletionMail; the `signed` route middleware rejects tampered/expired links before this runs. */
    public function confirm(AccountDeletionRequest $accountDeletionRequest): RedirectResponse
    {
        $locale = $accountDeletionRequest->locale ?: 'en';
        $t = AccountDeletionCopy::text($locale);

        if ($accountDeletionRequest->confirmed_at) {
            return redirect()->route('account.delete.form', ['lang' => $locale])->with('account_deleted', true);
        }

        $customer = Customer::find($accountDeletionRequest->customer_id);

        if (! $customer) {
            $accountDeletionRequest->update(['confirmed_at' => now()]);

            return redirect()->route('account.delete.form', ['lang' => $locale])->with('account_deleted', true);
        }

        if ($this->hasActiveBooking($customer)) {
            return redirect()->route('account.delete.form', ['lang' => $locale])
                ->withErrors(['phone' => $t['error_active_booking_confirm']]);
        }

        $this->deleteCustomer($customer, $accountDeletionRequest->email, $locale, existingRequest: $accountDeletionRequest);

        return redirect()->route('account.delete.form', ['lang' => $locale])->with('account_deleted', true);
    }

    /**
     * The app tells us its language via `?lang=`; that wins whenever present
     * and is remembered in the session for the rest of this GET→POST→redirect
     * flow. Without it (e.g. the link was opened outside the app), falls back
     * to the browser's Accept-Language header, then English.
     */
    private function resolveLocale(Request $request): string
    {
        $explicit = AccountDeletionCopy::normalize($request->query('lang'));

        if ($explicit) {
            $request->session()->put(self::SESSION_KEY, $explicit);

            return $explicit;
        }

        return $request->session()->get(self::SESSION_KEY)
            ?? Locale::resolve($request->header('Accept-Language'));
    }

    private function hasActiveBooking(Customer $customer): bool
    {
        return $customer->bookings()->whereIn('status', Booking::ACTIVE_STATUSES)->exists();
    }

    private function deleteCustomer(Customer $customer, string $email, string $locale, ?string $reason = null, ?AccountDeletionRequest $existingRequest = null): void
    {
        $name = $customer->name;

        DB::transaction(function () use ($customer, $email, $reason, $locale, $existingRequest, $name) {
            if ($existingRequest) {
                $existingRequest->update(['confirmed_at' => now()]);
            } else {
                AccountDeletionRequest::create([
                    'customer_id' => $customer->id,
                    'name' => $name,
                    'phone' => $customer->phone,
                    'email' => $email,
                    'reason' => $reason,
                    'locale' => $locale,
                    'confirmed_at' => now(),
                ]);
            }

            // Bookings, bulk bookings, reviews, and support tickets all cascade-delete
            // via their customer_id foreign key; tokens don't, so drop those explicitly.
            $customer->tokens()->delete();
            $customer->delete();
        });

        // Queued only after the transaction above has actually committed, so a
        // failed/rolled-back deletion never results in a false "deleted" email.
        Mail::to($email)->queue(new AccountDeletedMail($name, $locale));
    }
}
