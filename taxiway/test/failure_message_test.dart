import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxiway/core/api/api_client.dart';
import 'package:taxiway/core/api/network_failure.dart';
import 'package:taxiway/core/utils/failure_message.dart';
import 'package:taxiway/l10n/generated/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  FailureText describe(Object error) => describeFailure(l10n, error, fallback: 'FALLBACK', title: 'TITLE');

  test('offline and timeout get their own explanation', () {
    final offline = describe(const NetworkFailure(NetworkFailureKind.offline));
    expect(offline.title, l10n.errorOfflineTitle);
    expect(offline.message, l10n.errorOfflineMessage);

    final timeout = describe(const NetworkFailure(NetworkFailureKind.timeout));
    expect(timeout.title, l10n.errorTimeoutTitle);
    expect(timeout.message, l10n.errorTimeoutMessage);
  });

  test('server errors say it is not the user\'s connection', () {
    final text = describe(const ApiException(503, 'Service Unavailable'));
    expect(text.title, l10n.errorServerTitle);
    expect(text.message, l10n.errorServerMessage);
  });

  test('a message the server chose to send is shown as it came', () {
    final text = describe(const ApiException(422, 'This ride has already been accepted by another driver.'));
    expect(text.message, 'This ride has already been accepted by another driver.');
    expect(text.title, 'TITLE');
  });

  test('a missing server message falls back to the localized fallback', () {
    final text = describe(const ApiException(404, ApiException.defaultMessage));
    expect(text.message, 'FALLBACK');
  });

  test('unknown errors fall back', () {
    expect(describe(StateError('boom')).message, 'FALLBACK');
  });
}
