import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:smart_auth/smart_auth.dart';

/// Listens for an incoming OTP SMS via Android's SMS User Consent API and
/// hands back the extracted code. No SMS permission is required — the OS
/// shows the user a one-tap consent sheet for the specific message.
///
/// This is the same hook a real SMS gateway (or a payment provider's OTP
/// step) will feed once one is wired up: whatever sends the text message,
/// as long as it contains a 4-8 digit code, gets picked up here unchanged.
class OtpAutoReadService {
  static final _smartAuth = SmartAuth.instance;

  /// Waits for the next OTP SMS to arrive and returns its code, or null if
  /// unsupported, canceled, or no SMS arrives before [listen] is disposed.
  static Future<String?> listen() async {
    if (kIsWeb || !Platform.isAndroid) return null;
    try {
      final result = await _smartAuth.getSmsWithUserConsentApi();
      return result.data?.code;
    } catch (_) {
      return null;
    }
  }

  /// Cancels an in-flight [listen] call — call this from dispose().
  static Future<void> cancel() async {
    if (kIsWeb || !Platform.isAndroid) return;
    await _smartAuth.removeUserConsentApiListener();
  }
}
