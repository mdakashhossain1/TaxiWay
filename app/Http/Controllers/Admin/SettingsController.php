<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ApiClient;
use App\Services\FirestoreService;
use App\Services\OtpService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\View\View;

class SettingsController extends Controller
{
    /** Cache-clearing actions exposed to the UI — never accept an arbitrary artisan command from the request. */
    private const CACHE_ACTIONS = [
        'all' => ['Cache', 'Clears all cached routes, views, config, and application data — run this after deploying code changes, plus PHP OPcache if available.', 'optimize:clear'],
    ];

    /** Must exactly match the decoded value in each app's android/app/src/main/cpp/native_secrets.cpp — DatabaseSeeder never ran on this deploy, so the mobile apps' actual embedded secrets were never stored here. */
    private const KNOWN_API_CLIENTS = [
        'taxiway' => 'AnHSxX9CiTc9TL0diRJznHA0SXSInmzFclWCrGyutPw96yTo3dCnfUwo9hRnqqIS',
        'taxiwaydriver' => 'W2v5crmw09yggblmPXhzcBIYEwqwHNMD6QPsIF4f2FpqjMAZO3du2t9eILche0jI',
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
            'missingApiClients' => $this->missingApiClients(),
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

    public function ensureApiClients(): RedirectResponse
    {
        $created = [];

        foreach (self::KNOWN_API_CLIENTS as $key => $secret) {
            ApiClient::updateOrCreate(
                ['client_key' => $key],
                ['name' => $key, 'client_secret' => $secret, 'is_active' => true],
            );
            $created[] = $key;
        }

        Artisan::call('config:clear');

        return redirect()->route('settings.index')->with('status', 'API clients ensured: '.implode(', ', $created).'.');
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
            'queueConnection' => config('queue.default'),
            'queuePendingCount' => $this->queueTableCount('jobs'),
            'queueFailedCount' => $this->queueTableCount('failed_jobs'),
        ]);
    }

    /**
     * Pushes a trivial closure job onto the real queue connection and
     * confirms it landed in the jobs table — proves QUEUE_CONNECTION, the
     * jobs table, and DriverVerifiedMail's ShouldQueue wiring all actually
     * work, without needing to wait for a real driver to be verified.
     * Doesn't wait for it to be *processed* — that happens on the next
     * `queue:work` run (every minute, via routes/console.php's schedule).
     */
    public function testQueue(): RedirectResponse
    {
        $before = $this->queueTableCount('jobs');

        if ($before === null) {
            return redirect()->route('settings.mail.edit')->with('queueTestResult', [
                'success' => false,
                'message' => "Can't read the jobs table — migrations may not have been run, or the database connection is unreachable.",
            ]);
        }

        try {
            dispatch(function () {
                Log::info('Queue test job executed at '.now()->toIso8601String());
            });
        } catch (\Throwable $e) {
            return redirect()->route('settings.mail.edit')->with('queueTestResult', [
                'success' => false,
                'message' => $e->getMessage(),
            ]);
        }

        $after = $this->queueTableCount('jobs');

        return redirect()->route('settings.mail.edit')->with('queueTestResult', [
            'success' => $after > $before,
            'message' => $after > $before
                ? "Job dispatched and confirmed in the jobs table ({$before} → {$after} pending). It'll run on the next scheduled queue:work — check back in a minute to see the pending count drop."
                : "Dispatch didn't throw, but the pending count didn't increase ({$before} → {$after}) — check QUEUE_CONNECTION in .env.",
        ]);
    }

    /** Null-safe count — returns null instead of throwing if the table doesn't exist (schema not migrated) or the DB connection is unreachable. */
    private function queueTableCount(string $table): ?int
    {
        try {
            return DB::table($table)->count();
        } catch (\Throwable $e) {
            return null;
        }
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
            'smsMode' => env('SMS_GATEWAY_MODE', config('services.sms.mode', 'otp')),
            'smsApiKey' => env('SMS_GATEWAY_API_KEY'),

            'otpMethod' => env('SMS_GATEWAY_OTP_METHOD', config('services.sms.otp.method', 'post')),
            'otpPayloadUrl' => env('SMS_GATEWAY_OTP_PAYLOAD_URL', config('services.sms.otp.payload_url')),
            'otpTemplateId' => env('SMS_GATEWAY_OTP_TEMPLATE_ID'),
            'otpPayloadTemplate' => env('SMS_GATEWAY_OTP_PAYLOAD_TEMPLATE', config('services.sms.otp.payload_template')),

            'dltMethod' => env('SMS_GATEWAY_DLT_METHOD', config('services.sms.dlt.method', 'get')),
            'dltPayloadUrl' => env('SMS_GATEWAY_DLT_PAYLOAD_URL', config('services.sms.dlt.payload_url')),
            'dltTemplateId' => env('SMS_GATEWAY_DLT_TEMPLATE_ID'),
            'dltSenderId' => env('SMS_GATEWAY_DLT_SENDER_ID'),
            'dltEntityId' => env('SMS_GATEWAY_DLT_ENTITY_ID'),
            'dltPayloadTemplate' => env('SMS_GATEWAY_DLT_PAYLOAD_TEMPLATE', config('services.sms.dlt.payload_template')),
        ]);
    }

    /** Sends a real message via the currently-saved gateway config, independent of the Live Mode toggle — lets an admin verify credentials before going live. */
    public function testSms(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'test_phone' => ['required', 'digits:10'],
            'test_mode' => ['nullable', 'in:otp,dlt'],
        ]);

        $result = $this->otp->sendTest($data['test_phone'], $data['test_mode'] ?? null);
        $route = strtoupper($result['mode'] ?? '');

        $flash = $result['success']
            ? ['status' => "Test SMS sent successfully via {$route} route."]
            : ['error' => "Test SMS failed via {$route} route".($result['status'] ? " — HTTP {$result['status']}" : '').'.'];

        return redirect()->route('settings.sms.edit')->with('smsTestResult', $result)->with($flash);
    }

    public function updateSms(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'sms_enabled' => ['nullable', 'boolean'],
            'sms_mode' => ['required', 'in:otp,dlt'],
            'sms_api_key' => ['nullable', 'string', 'max:255'],

            'otp_method' => ['nullable', 'in:get,post'],
            'otp_payload_url' => ['nullable', 'url', 'max:500'],
            'otp_template_id' => ['nullable', 'string', 'max:255'],
            'otp_payload_template' => ['nullable', 'string', 'max:2000'],

            'dlt_method' => ['nullable', 'in:get,post'],
            'dlt_payload_url' => ['nullable', 'url', 'max:500'],
            'dlt_template_id' => ['nullable', 'string', 'max:255'],
            'dlt_sender_id' => ['nullable', 'string', 'max:20'],
            'dlt_entity_id' => ['nullable', 'string', 'max:255'],
            'dlt_payload_template' => ['nullable', 'string', 'max:2000'],
        ]);

        if (filled($data['otp_payload_template'] ?? null) && json_decode($data['otp_payload_template']) === null) {
            return back()->withErrors(['otp_payload_template' => 'That is not valid JSON.'])->withInput();
        }

        if (filled($data['dlt_payload_template'] ?? null) && json_decode($data['dlt_payload_template']) === null) {
            return back()->withErrors(['dlt_payload_template' => 'That is not valid JSON.'])->withInput();
        }

        $this->setEnvValue('SMS_GATEWAY_ENABLED', $request->boolean('sms_enabled') ? 'true' : 'false');
        $this->setEnvValue('SMS_GATEWAY_MODE', $data['sms_mode']);

        foreach ([
            'SMS_GATEWAY_OTP_METHOD' => $data['otp_method'] ?? null,
            'SMS_GATEWAY_OTP_PAYLOAD_URL' => $data['otp_payload_url'] ?? null,
            'SMS_GATEWAY_OTP_TEMPLATE_ID' => $data['otp_template_id'] ?? null,
            'SMS_GATEWAY_OTP_PAYLOAD_TEMPLATE' => $data['otp_payload_template'] ?? null,
            'SMS_GATEWAY_DLT_METHOD' => $data['dlt_method'] ?? null,
            'SMS_GATEWAY_DLT_PAYLOAD_URL' => $data['dlt_payload_url'] ?? null,
            'SMS_GATEWAY_DLT_TEMPLATE_ID' => $data['dlt_template_id'] ?? null,
            'SMS_GATEWAY_DLT_SENDER_ID' => $data['dlt_sender_id'] ?? null,
            'SMS_GATEWAY_DLT_ENTITY_ID' => $data['dlt_entity_id'] ?? null,
            'SMS_GATEWAY_DLT_PAYLOAD_TEMPLATE' => $data['dlt_payload_template'] ?? null,
            'SMS_GATEWAY_API_KEY' => $data['sms_api_key'] ?? null,
        ] as $key => $value) {
            // Blank fields are left untouched rather than overwritten, so an empty
            // "the other profile's" section on save doesn't wipe out its defaults
            // or a previously-saved value (e.g. the API key input is always blank).
            if (filled($value)) {
                $this->setEnvValue($key, $value);
            }
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

    private function missingApiClients(): array
    {
        $existing = ApiClient::whereIn('client_key', array_keys(self::KNOWN_API_CLIENTS))
            ->where('is_active', true)
            ->pluck('client_key')
            ->all();

        return array_values(array_diff(array_keys(self::KNOWN_API_CLIENTS), $existing));
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
