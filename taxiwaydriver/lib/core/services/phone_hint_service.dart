import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_auth/smart_auth.dart';

class PhoneHintService {
  static final _smartAuth = SmartAuth.instance;

  /// Requests the driver's phone number using Google Play Services Phone Number Hint API.
  /// Returns null if unavailable/dismissed — the caller falls back to manual entry.
  static Future<String?> requestPhoneNumber(BuildContext context) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final res = await _smartAuth.requestPhoneNumberHint();
        if (res.data != null && res.data!.isNotEmpty) {
          return _cleanPhoneNumber(res.data!);
        }
      }
    } catch (_) {
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
