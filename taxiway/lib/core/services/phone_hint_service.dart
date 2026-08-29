import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_auth/smart_auth.dart';
import '../widgets/sim_phone_picker_sheet.dart';

class PhoneHintService {
  static final _smartAuth = SmartAuth.instance;

  /// Requests the user's phone number using Google Play Services Phone Number Hint API,
  /// falling back gracefully to the in-app SIM selector bottom sheet.
  static Future<String?> requestPhoneNumber(BuildContext context) async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        final res = await _smartAuth.requestPhoneNumberHint();
        if (res.data != null && res.data!.isNotEmpty) {
          return _cleanPhoneNumber(res.data!);
        }
      }
    } catch (_) {
      // Ignored: proceed to fallback bottom sheet
    }

    // Fallback SIM Picker modal
    if (context.mounted) {
      final selected = await SimPhonePickerSheet.show(context);
      if (selected != null && selected.isNotEmpty) {
        return _cleanPhoneNumber(selected);
      }
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
