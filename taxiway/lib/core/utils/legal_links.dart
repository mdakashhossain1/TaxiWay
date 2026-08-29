import 'package:url_launcher/url_launcher.dart';

/// Replace these with your real hosted Terms & Conditions / Privacy Policy
/// pages — required for Play Store / App Store submission. These placeholder
/// URLs use IANA's reserved example.com domain, safe to ship until then.
const String kTermsAndConditionsUrl = 'https://example.com/taxiway/terms';
const String kPrivacyPolicyUrl = 'https://example.com/taxiway/privacy';

/// Opens [url] in an in-app browser — Chrome Custom Tabs on Android,
/// SFSafariViewController on iOS — so the page stays presented within the
/// app rather than backgrounding it to launch a separate browser app.
Future<void> openInAppBrowser(String url) {
  return launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
}
