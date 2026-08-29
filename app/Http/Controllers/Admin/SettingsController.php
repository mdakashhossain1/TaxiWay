<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Services\FirestoreService;
use App\Services\OtpService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Illuminate\View\View;

class SettingsController extends Controller
{
    /** Cache-clearing actions exposed to the UI — never accept an arbitrary artisan command from the request. */
    private const CACHE_ACTIONS = [
        'all' => ['Cache', 'Clears all cached routes, views, config, and application data — run this after deploying code changes, plus PHP OPcache if available.', 'optimize:clear'],
    ];

    public function __construct(
        private readonly OtpService $otp,
        private readonly FirestoreService $firestore,
    ) {
    }

    public function index(): View
    {
        return view('pages.admin.settings.index', [
            'title' => 'Settings',
            'firebaseConfigured' => $this->firebaseConfigured(),
            'mailConfigured' => $this->mailConfigured(),
            'smsGatewayEnabled' => (bool) config('services.sms.enabled'),
            'contactConfigured' => filled(env('SUPPORT_CONTACT_NUMBER')),
            'cacheActions' => self::CACHE_ACTIONS,
            'opcacheEnabled' => function_exists('opcache_reset'),
            'pendingMigrations' => $this->pendingMigrations(),
        ]);
    }

    /**
     * Lets an admin apply schema changes after a plain file upload, since
     * Hostinger shared hosting has no reliable SSH/CLI access to run
     * `php artisan migrate` directly.
     */
    public function runMigrations(): RedirectResponse
    {
        $pending = $this->pendingMigrations();

        if ($pending !== null && count($pending) === 0) {
            return redirect()->route('settings.index')->with('status', 'Already up to date — no pending migrations.');
        }

        Artisan::call('migrate', ['--force' => true]);

        $pendingBefore = $pending !== null ? count($pending) : null;

        return redirect()->route('settings.index')->with(
            'status',
            $pendingBefore !== null ? "Ran {$pendingBefore} migration(s)." : 'Migration command ran — check migration status below.'
        );
    }

    public function editMail(): View
    {
        return view('pages.admin.settings.mail', [
            'title' => 'Mail Settings',
            'mailHost' => env('MAIL_HOST'),
            'mailPort' => env('MAIL_PORT'),
            'mailUsername' => env('MAIL_USERNAME'),
            'mailFromAddress' => env('MAIL_FROM_ADDRESS'),
            'mailFromName' => env('MAIL_FROM_NAME'),
        ]);
    }

    public function updateMail(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'mail_host' => ['required', 'string', 'max:255'],
            'mail_port' => ['required', 'integer'],
            'mail_username' => ['required', 'string', 'max:255'],
            'mail_password' => ['nullable', 'string', 'max:255'],
            'mail_from_address' => ['required', 'email', 'max:255'],
            'mail_from_name' => ['required', 'string', 'max:255'],
        ]);

        $this->setEnvValue('MAIL_MAILER', 'smtp');
        $this->setEnvValue('MAIL_HOST', $data['mail_host']);
        $this->setEnvValue('MAIL_PORT', (string) $data['mail_port']);
        $this->setEnvValue('MAIL_USERNAME', $data['mail_username']);
        $this->setEnvValue('MAIL_FROM_ADDRESS', $data['mail_from_address']);
        $this->setEnvValue('MAIL_FROM_NAME', $data['mail_from_name']);

        if (filled($data['mail_password'] ?? null)) {
            $this->setEnvValue('MAIL_PASSWORD', $data['mail_password']);
        }

        Artisan::call('config:clear');

        return redirect()->route('settings.mail.edit')->with('status', 'Mail settings updated.');
    }

    public function editSms(): View
    {
        return view('pages.admin.settings.sms', [
            'title' => 'SMS Gateway',
            'smsEnabled' => (bool) env('SMS_GATEWAY_ENABLED', false),
            'smsApiKey' => env('SMS_GATEWAY_API_KEY'),
            'smsPayloadUrl' => env('SMS_GATEWAY_PAYLOAD_URL'),
            'smsTemplateId' => env('SMS_GATEWAY_TEMPLATE_ID'),
            'smsPayloadTemplate' => env('SMS_GATEWAY_PAYLOAD_TEMPLATE', config('services.sms.payload_template')),
        ]);
    }

    /** Sends a real message via the currently-saved gateway config, independent of the Live Mode toggle — lets an admin verify credentials before going live. */
    public function testSms(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'test_phone' => ['required', 'digits:10'],
        ]);

        $result = $this->otp->sendTest($data['test_phone']);

        return redirect()->route('settings.sms.edit')->with('smsTestResult', $result);
    }

    public function updateSms(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'sms_enabled' => ['nullable', 'boolean'],
            'sms_api_key' => ['nullable', 'string', 'max:255'],
            'sms_payload_url' => ['required', 'url', 'max:500'],
            'sms_template_id' => ['nullable', 'string', 'max:255'],
            'sms_payload_template' => ['required', 'string', 'max:2000'],
        ]);

        if (json_decode($data['sms_payload_template']) === null) {
            return back()->withErrors(['sms_payload_template' => 'That is not valid JSON.'])->withInput();
        }

        $this->setEnvValue('SMS_GATEWAY_ENABLED', $request->boolean('sms_enabled') ? 'true' : 'false');
        $this->setEnvValue('SMS_GATEWAY_PAYLOAD_URL', $data['sms_payload_url']);
        $this->setEnvValue('SMS_GATEWAY_TEMPLATE_ID', $data['sms_template_id'] ?? '');
        $this->setEnvValue('SMS_GATEWAY_PAYLOAD_TEMPLATE', $data['sms_payload_template']);

        if (filled($data['sms_api_key'] ?? null)) {
            $this->setEnvValue('SMS_GATEWAY_API_KEY', $data['sms_api_key']);
        }

        Artisan::call('config:clear');

        return redirect()->route('settings.sms.edit')->with('status', 'SMS gateway settings updated.');
    }

    public function editContact(): View
    {
        return view('pages.admin.settings.contact', [
            'title' => 'Contact Number',
            'contactNumber' => env('SUPPORT_CONTACT_NUMBER'),
        ]);
    }

    public function updateContact(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'contact_number' => ['required', 'string', 'max:20'],
        ]);

        $this->setEnvValue('SUPPORT_CONTACT_NUMBER', $data['contact_number']);

        Artisan::call('config:clear');

        return redirect()->route('settings.contact.edit')->with('status', 'Contact number updated.');
    }

    public function editFirebase(): View
    {
        $credentialsPath = storage_path('app/private/firebase-credentials.json');

        return view('pages.admin.settings.firebase', [
            'title' => 'Firebase Credentials',
            'firebaseProjectId' => env('FIREBASE_PROJECT_ID'),
            'firebaseWebApiKey' => env('FIREBASE_WEB_API_KEY'),
            'firebaseCredentialsConfigured' => File::exists($credentialsPath),
            'firebaseCredentialsUpdatedAt' => File::exists($credentialsPath) ? File::lastModified($credentialsPath) : null,
        ]);
    }

    public function updateFirebase(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'firebase_project_id' => ['required', 'string', 'max:255'],
            'firebase_web_api_key' => ['nullable', 'string', 'max:255'],
            'credentials_file' => ['nullable', 'file', 'max:512'],
        ]);

        $this->setEnvValue('FIREBASE_PROJECT_ID', $data['firebase_project_id']);
        $this->setEnvValue('FIREBASE_WEB_API_KEY', $data['firebase_web_api_key'] ?? '');

        if ($request->hasFile('credentials_file')) {
            $json = file_get_contents($request->file('credentials_file')->getRealPath());
            $decoded = json_decode($json, true);

            if (! is_array($decoded) || ($decoded['type'] ?? null) !== 'service_account' || empty($decoded['private_key']) || empty($decoded['client_email'])) {
                return back()->withErrors(['credentials_file' => 'That does not look like a valid Firebase service-account JSON file.']);
            }

            $path = storage_path('app/private');
            File::ensureDirectoryExists($path);
            File::put($path.'/firebase-credentials.json', $json);

            $this->setEnvValue('FIREBASE_CREDENTIALS', $path.'/firebase-credentials.json');
        }

        Artisan::call('config:clear');

        return redirect()->route('settings.firebase.edit')->with('status', 'Firebase settings updated.');
    }

    /** Signs in as the service account and writes a throwaway Firestore document to confirm the whole chain actually works. */
    public function testFirebase(): RedirectResponse
    {
        $result = $this->firestore->testConnection();

        return redirect()->route('settings.firebase.edit')->with('firebaseTestResult', $result);
    }

    public function clearCache(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'action' => ['required', 'in:'.implode(',', array_keys(self::CACHE_ACTIONS))],
        ]);

        Artisan::call(self::CACHE_ACTIONS[$data['action']][2]);

        if (function_exists('opcache_reset')) {
            opcache_reset();
        }

        return redirect()->route('settings.index')->with('status', self::CACHE_ACTIONS[$data['action']][0].' cleared.');
    }

    private function firebaseConfigured(): bool
    {
        return (bool) env('FIREBASE_PROJECT_ID') && File::exists(storage_path('app/private/firebase-credentials.json'));
    }

    private function mailConfigured(): bool
    {
        return env('MAIL_MAILER') === 'smtp' && (bool) env('MAIL_HOST') && (bool) env('MAIL_USERNAME');
    }

    /** Returns pending migration names, or null if the status can't be determined (e.g. DB not reachable) — distinct from "0 pending". */
    private function pendingMigrations(): ?array
    {
        try {
            $migrator = app('migrator');
            $files = $migrator->getMigrationFiles(database_path('migrations'));
            $ran = $migrator->getRepository()->repositoryExists() ? $migrator->getRepository()->getRan() : [];

            return array_values(array_diff(array_keys($files), $ran));
        } catch (\Throwable $e) {
            return null;
        }
    }

    /** Rewrites (or appends) a single KEY=VALUE line in the root .env file. */
    private function setEnvValue(string $key, string $value): void
    {
        $envPath = base_path('.env');
        $content = File::exists($envPath) ? File::get($envPath) : '';

        $needsQuoting = $value === '' || preg_match('/\s|#/', $value);
        $formatted = $needsQuoting ? '"'.str_replace('"', '\"', $value).'"' : $value;

        $pattern = '/^'.preg_quote($key, '/').'=.*/m';

        $content = preg_match($pattern, $content)
            ? preg_replace($pattern, "{$key}={$formatted}", $content)
            : rtrim($content).PHP_EOL."{$key}={$formatted}".PHP_EOL;

        File::put($envPath, $content);
    }
}
