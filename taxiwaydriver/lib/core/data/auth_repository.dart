import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../models/driver_profile.dart';

class InvalidOtpException implements Exception {
  final bool expired;
  const InvalidOtpException({this.expired = false});
}

class GoogleLoginResult {
  final DriverProfile driver;
  final bool phoneLinked;
  const GoogleLoginResult({required this.driver, required this.phoneLinked});
}

abstract class AuthRepository {
  /// Returns the OTP code when the backend echoes one back (non-production
  /// builds only, since no SMS gateway is wired up), otherwise null.
  Future<String?> sendOtp(String phone);
  Future<DriverProfile> verifyOtp(String phone, String code);
  Future<GoogleLoginResult> loginWithGoogle(String idToken);
  Future<String?> sendPhoneLinkOtp(String phone);
  Future<DriverProfile> confirmPhoneLink(String phone, String code);
  Future<void> registerDeviceToken(String fcmToken);
  Future<DriverProfile?> getSession();
  Future<void> clearSession();
}

class ApiAuthRepositoryImpl implements AuthRepository {
  static const _storage = FlutterSecureStorage();
  static const _sessionKey = 'driver_session';

  Future<void> _saveSession(DriverProfile driver) =>
      _storage.write(key: _sessionKey, value: jsonEncode(driver.toJson()));

  @override
  Future<DriverProfile?> getSession() async {
    final token = await ApiClient.instance.readToken();
    final raw = await _storage.read(key: _sessionKey);
    if (token == null || raw == null) return null;
    try {
      return DriverProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearSession() => _storage.delete(key: _sessionKey);

  @override
  Future<String?> sendOtp(String phone) async {
    final response = await ApiClient.instance.post('/driver/auth/send-otp', body: {'phone': phone}, auth: false);
    return response['debug_otp'] as String?;
  }

  @override
  Future<DriverProfile> verifyOtp(String phone, String code) async {
    try {
      final response = await ApiClient.instance.post(
        '/driver/auth/verify-otp',
        body: {'phone': phone, 'code': code},
        auth: false,
      );
      final data = response['data'] as Map<String, dynamic>;
      await ApiClient.instance.saveToken(data['token'] as String);
      final driver = DriverProfile.fromJson(data['driver'] as Map<String, dynamic>);
      await _saveSession(driver);
      return driver;
    } on ApiException catch (e) {
      if (e.statusCode == 422) throw InvalidOtpException(expired: e.expired);
      rethrow;
    }
  }

  @override
  Future<GoogleLoginResult> loginWithGoogle(String idToken) async {
    final response = await ApiClient.instance.post(
      '/driver/auth/google',
      body: {'id_token': idToken},
      auth: false,
    );
    final data = response['data'] as Map<String, dynamic>;
    await ApiClient.instance.saveToken(data['token'] as String);
    final driver = DriverProfile.fromJson(data['driver'] as Map<String, dynamic>);
    final phoneLinked = data['phone_linked'] as bool;
    if (phoneLinked) await _saveSession(driver);
    return GoogleLoginResult(driver: driver, phoneLinked: phoneLinked);
  }

  @override
  Future<String?> sendPhoneLinkOtp(String phone) async {
    final response = await ApiClient.instance.post('/driver/auth/phone/send-otp', body: {'phone': phone});
    return response['debug_otp'] as String?;
  }

  @override
  Future<DriverProfile> confirmPhoneLink(String phone, String code) async {
    try {
      final response = await ApiClient.instance.post(
        '/driver/auth/phone/verify',
        body: {'phone': phone, 'code': code},
      );
      final data = (response['data'] as Map<String, dynamic>)['driver'] as Map<String, dynamic>;
      final driver = DriverProfile.fromJson(data);
      await _saveSession(driver);
      return driver;
    } on ApiException catch (e) {
      if (e.statusCode == 422) throw InvalidOtpException(expired: e.expired);
      rethrow;
    }
  }

  @override
  Future<void> registerDeviceToken(String fcmToken) async {
    try {
      await ApiClient.instance.post('/driver/device-token', body: {'fcm_token': fcmToken});
    } on ApiException {
      // Non-fatal — pushes just won't reach this device until the next
      // successful registration attempt (e.g. next app launch/token refresh).
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => ApiAuthRepositoryImpl());
