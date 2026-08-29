import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Fetches the HMAC client secret from the native (C++/JNI) layer on
/// Android instead of holding it as a plain Dart constant — see
/// android/app/src/main/cpp/native_secrets.cpp for why. Call [load] once
/// during app startup, before the first signed API request; [secret] reads
/// the cached value afterward.
class NativeSecrets {
  NativeSecrets._();

  static const _channel = MethodChannel('com.taxiway.user.arknox/native_secrets');
  static String? _secret;

  static String get secret {
    final value = _secret;
    if (value == null) {
      throw StateError('NativeSecrets.load() must complete before the API client secret is read.');
    }
    return value;
  }

  static Future<void> load() async {
    if (_secret != null) return;

    // kDebugMode is a compile-time constant (unlike Platform.isAndroid), so
    // Dart AOT provably eliminates this whole branch — and _fallbackSecret
    // with it — from release builds. Without that guard, the "fallback"
    // string would still get compiled into a release libapp.so on Android
    // too, since Platform.isAndroid can't be const-folded away.
    if (kDebugMode && !Platform.isAndroid) {
      // This project doesn't actually ship desktop/web builds — the
      // scaffolding exists, but there's no native implementation for them.
      _secret = _fallbackSecret;
      return;
    }

    if (!Platform.isAndroid) {
      throw UnsupportedError('NativeSecrets has no implementation for this platform.');
    }

    _secret = await _channel.invokeMethod<String>('getApiClientSecret');
  }
}

const _fallbackSecret = 'AnHSxX9CiTc9TL0diRJznHA0SXSInmzFclWCrGyutPw96yTo3dCnfUwo9hRnqqIS';
