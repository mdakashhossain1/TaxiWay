/// Points at the Laravel backend.
const String kApiBaseUrl = 'https://cornflowerblue-stingray-110031.hostingersite.com/api';

/// This app's HMAC identity, matching the `api_clients` row seeded by the
/// Laravel backend's DatabaseSeeder. The matching secret lives in
/// NativeSecrets (native_secrets.dart) instead of here — see that file and
/// android/app/src/main/cpp/native_secrets.cpp for why. Baking a static
/// secret into the app at all, even natively, is a known simplification for
/// this project's stage — a production build would instead prove app
/// authenticity via platform attestation (Play Integrity / App Attest)
/// rather than an embedded shared secret.
const String kApiClientKey = 'taxiwaydriver';
