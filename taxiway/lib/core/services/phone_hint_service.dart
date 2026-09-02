import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_auth/smart_auth.dart';
import '../widgets/phone_fetch_progress_dialog.dart';

class PhoneHintService {
  static final _smartAuth = SmartAuth.instance;

  /// Requests the user's phone number using Google Play Services Phone Number Hint API.
  /// Returns null if unavailable/dismissed — the caller falls back to manual entry.
  static Future<String?> requestPhoneNumber(BuildContext context) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        // Play Services can take a moment to load the picker — show a
        // processing dialog so the screen never looks blank in that gap.
        await PhoneFetchProgressDialog.show(context);
        try {
          final res = await _smartAuth.requestPhoneNumberHint();
          if (res.data != null && res.data!.isNotEmpty) {
            return _cleanPhoneNumber(res.data!);
          }
        } finally {
          if (context.mounted) PhoneFetchProgressDialog.hide(context);
        }
      }
    } catch (_) {
      if (context.mounted) PhoneFetchProgressDialog.hide(context);
      // Ignored: caller falls back to manual entry
    }

    return null;
  }

  /// Extracts the clean 10-digit phone number.
  static String _cleanPhoneNumber(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 10) {
      return digitsOnly.substring(digitsOnly.length - 10);
    }
    return digitsOnly;
  }
}
