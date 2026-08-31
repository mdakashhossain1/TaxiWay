<?php

use App\Http\Controllers\AccountDeletionController;
use App\Http\Controllers\Admin\AccountDeletionController as AdminAccountDeletionController;
use App\Http\Controllers\Admin\BookingController as AdminBookingController;
use App\Http\Controllers\Admin\BulkBookingController as AdminBulkBookingController;
use App\Http\Controllers\Admin\CalendarController as AdminCalendarController;
use App\Http\Controllers\Admin\CustomerController as AdminCustomerController;
use App\Http\Controllers\Admin\DriverController as AdminDriverController;
use App\Http\Controllers\Admin\DriverDocumentController as AdminDriverDocumentController;
use App\Http\Controllers\Admin\DriverSubscriptionController as AdminDriverSubscriptionController;
use App\Http\Controllers\Admin\DriverSubscriptionPlanController as AdminDriverSubscriptionPlanController;
use App\Http\Controllers\Admin\EmailTemplateController as AdminEmailTemplateController;
use App\Http\Controllers\Admin\SearchController as AdminSearchController;
use App\Http\Controllers\Admin\SettingsController as AdminSettingsController;
use App\Http\Controllers\Admin\SupportChatController as AdminSupportChatController;
use App\Http\Controllers\Admin\VehicleCategoryController as AdminVehicleCategoryController;
use App\Http\Controllers\Admin\VehicleController as AdminVehicleController;
use App\Http\Controllers\Auth\SessionController;
use App\Http\Controllers\CronController;
use App\Http\Controllers\DashboardController;
use Illuminate\Support\Facades\Route;

// HTTP-triggerable equivalent of crontab's `php artisan schedule:run`, for
// an external server hitting this over HTTP instead of a local cron —
// deliberately outside the guest/auth groups below: the caller has no admin
// session, just the CRON_SECRET token. See CronController for why a bad
// token 404s instead of 403.
Route::get('/cron/run', [CronController::class, 'run'])->name('cron.run');

// Public, unauthenticated account-deletion page linked from the taxiway app's
// profile menu. No login/OTP step by design — see AccountDeletionController.
Route::get('/account/delete', [AccountDeletionController::class, 'show'])->name('account.delete.form');
Route::post('/account/delete', [AccountDeletionController::class, 'destroy'])
    ->middleware('throttle:6,1')
    ->name('account.delete.destroy');
Route::get('/account/delete/confirm/{accountDeletionRequest}', [AccountDeletionController::class, 'confirm'])
    ->middleware('signed')
    ->name('account.delete.confirm');

// guest-only authentication pages
Route::middleware('guest')->group(function () {
    Route::get('/signin', [SessionController::class, 'create'])->name('signin');
    Route::post('/signin', [SessionController::class, 'store'])->name('login');
});

// everything else requires an authenticated admin session
Route::middleware('auth')->group(function () {
    Route::post('/logout', [SessionController::class, 'destroy'])->name('logout');

    // dashboard pages
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');

    // calender pages
    Route::get('/calendar', [AdminCalendarController::class, 'index'])->name('calendar');

    // profile pages
    Route::get('/profile', function () {
        return view('pages.profile', ['title' => 'Profile']);
    })->name('profile');

    // global search (header search bar, available on every page)
    Route::get('/search', [AdminSearchController::class, 'index'])->name('search');

    // Taxiway admin management
    // bulk-destroy routes must be registered before their resource/{param} siblings,
    // otherwise "bulk-destroy" is swallowed by the {param} wildcard.
    Route::delete('drivers/bulk-destroy', [AdminDriverController::class, 'bulkDestroy'])->name('drivers.bulk-destroy');
    Route::resource('drivers', AdminDriverController::class);
    Route::post('drivers/{driver}/verify', [AdminDriverController::class, 'verify'])->name('drivers.verify');
    Route::post('drivers/{driver}/suspend', [AdminDriverController::class, 'suspend'])->name('drivers.suspend');
    Route::post('drivers/{driver}/documents', [AdminDriverDocumentController::class, 'store'])->name('drivers.documents.store');
    Route::get('drivers/{driver}/documents/{document}', [AdminDriverDocumentController::class, 'download'])->name('drivers.documents.download');
    Route::delete('drivers/{driver}/documents/{document}', [AdminDriverDocumentController::class, 'destroy'])->name('drivers.documents.destroy');

    Route::delete('vehicles/bulk-destroy', [AdminVehicleController::class, 'bulkDestroy'])->name('vehicles.bulk-destroy');
    Route::resource('vehicles', AdminVehicleController::class);

    Route::delete('vehicle-categories/bulk-destroy', [AdminVehicleCategoryController::class, 'bulkDestroy'])->name('vehicle-categories.bulk-destroy');
    Route::resource('vehicle-categories', AdminVehicleCategoryController::class);

    Route::get('customers', [AdminCustomerController::class, 'index'])->name('customers.index');
    Route::delete('customers/bulk-destroy', [AdminCustomerController::class, 'bulkDestroy'])->name('customers.bulk-destroy');
    Route::get('customers/{customer}', [AdminCustomerController::class, 'show'])->name('customers.show');
    Route::get('customers/{customer}/edit', [AdminCustomerController::class, 'edit'])->name('customers.edit');
    Route::put('customers/{customer}', [AdminCustomerController::class, 'update'])->name('customers.update');
    Route::delete('customers/{customer}', [AdminCustomerController::class, 'destroy'])->name('customers.destroy');

    Route::get('account-deletions', [AdminAccountDeletionController::class, 'index'])->name('account-deletions.index');
    Route::delete('account-deletions/bulk-destroy', [AdminAccountDeletionController::class, 'bulkDestroy'])->name('account-deletions.bulk-destroy');

    Route::get('bookings', [AdminBookingController::class, 'index'])->name('bookings.index');
    Route::delete('bookings/bulk-destroy', [AdminBookingController::class, 'bulkDestroy'])->name('bookings.bulk-destroy');
    Route::get('bookings/{booking}', [AdminBookingController::class, 'show'])->name('bookings.show');
    Route::patch('bookings/{booking}/status', [AdminBookingController::class, 'updateStatus'])->name('bookings.update-status');
    Route::delete('bookings/{booking}', [AdminBookingController::class, 'destroy'])->name('bookings.destroy');

    Route::get('driver-subscriptions', [AdminDriverSubscriptionController::class, 'index'])->name('driver-subscriptions.index');
    Route::delete('driver-subscriptions/bulk-destroy', [AdminDriverSubscriptionController::class, 'bulkDestroy'])->name('driver-subscriptions.bulk-destroy');
    Route::get('driver-subscriptions/create', [AdminDriverSubscriptionController::class, 'create'])->name('driver-subscriptions.create');
    Route::post('driver-subscriptions', [AdminDriverSubscriptionController::class, 'store'])->name('driver-subscriptions.store');
    Route::get('driver-subscriptions/{driverSubscription}', [AdminDriverSubscriptionController::class, 'show'])->name('driver-subscriptions.show');
    Route::get('driver-subscriptions/{driverSubscription}/edit', [AdminDriverSubscriptionController::class, 'edit'])->name('driver-subscriptions.edit');
    Route::put('driver-subscriptions/{driverSubscription}', [AdminDriverSubscriptionController::class, 'update'])->name('driver-subscriptions.update');
    Route::delete('driver-subscriptions/{driverSubscription}', [AdminDriverSubscriptionController::class, 'destroy'])->name('driver-subscriptions.destroy');

    Route::resource('driver-subscription-plans', AdminDriverSubscriptionPlanController::class)->except(['show']);

    Route::get('bulk-bookings/{bulkBooking}', [AdminBulkBookingController::class, 'show'])->name('bulk-bookings.show');

    Route::get('settings', [AdminSettingsController::class, 'index'])->name('settings.index');
    Route::get('settings/contact', [AdminSettingsController::class, 'editContact'])->name('settings.contact.edit');
    Route::post('settings/contact', [AdminSettingsController::class, 'updateContact'])->name('settings.contact.update');
    Route::get('settings/support-chat', [AdminSupportChatController::class, 'index'])->name('settings.support-chat.index');
    Route::get('settings/support-chat/token', [AdminSupportChatController::class, 'token'])->name('settings.support-chat.token');
    Route::get('settings/firebase', [AdminSettingsController::class, 'editFirebase'])->name('settings.firebase.edit');
    Route::post('settings/firebase', [AdminSettingsController::class, 'updateFirebase'])->name('settings.firebase.update');
    Route::post('settings/firebase/test', [AdminSettingsController::class, 'testFirebase'])->name('settings.firebase.test');
    Route::get('settings/mail', [AdminSettingsController::class, 'editMail'])->name('settings.mail.edit');
    Route::post('settings/mail', [AdminSettingsController::class, 'updateMail'])->name('settings.mail.update');
    Route::post('settings/mail/test-queue', [AdminSettingsController::class, 'testQueue'])->name('settings.mail.test-queue');
    Route::get('settings/sms', [AdminSettingsController::class, 'editSms'])->name('settings.sms.edit');
    Route::post('settings/sms', [AdminSettingsController::class, 'updateSms'])->name('settings.sms.update');
    Route::post('settings/sms/test', [AdminSettingsController::class, 'testSms'])->name('settings.sms.test');
    Route::post('settings/cache', [AdminSettingsController::class, 'clearCache'])->name('settings.cache');
    Route::post('settings/migrate', [AdminSettingsController::class, 'runMigrations'])->name('settings.migrate');
    Route::post('settings/api-clients', [AdminSettingsController::class, 'ensureApiClients'])->name('settings.api-clients');

    Route::get('email-templates', [AdminEmailTemplateController::class, 'index'])->name('email-templates.index');
    Route::get('email-templates/{emailTemplate}/edit', [AdminEmailTemplateController::class, 'edit'])->name('email-templates.edit');
    Route::put('email-templates/{emailTemplate}', [AdminEmailTemplateController::class, 'update'])->name('email-templates.update');
});
