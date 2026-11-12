import '../../l10n/generated/app_localizations.dart';
import '../api/api_client.dart';
import '../api/network_failure.dart';

class FailureText {
  final String message;
  final String? title;

  const FailureText(this.message, {this.title});

  String get headline => title ?? message;
}

/// Turns whatever an action threw into what the user should read: connection
/// problems and server trouble get their own explanation (so nobody is told
/// "failed" when they were just offline), a message the server chose to send
/// is shown as it came, and anything else falls back to [fallback].
FailureText describeFailure(
  AppLocalizations l10n,
  Object error, {
  required String fallback,
  String? title,
}) {
  if (error is NetworkFailure) {
    return error.kind == NetworkFailureKind.timeout
        ? FailureText(l10n.errorTimeoutMessage, title: l10n.errorTimeoutTitle)
        : FailureText(l10n.errorOfflineMessage, title: l10n.errorOfflineTitle);
  }
  if (error is ApiException) {
    if (error.statusCode >= 500) {
      return FailureText(l10n.errorServerMessage, title: l10n.errorServerTitle);
    }
    if (error.message != ApiException.defaultMessage) {
      return FailureText(error.message, title: title);
    }
  }
  return FailureText(fallback, title: title);
}
