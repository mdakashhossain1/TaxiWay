import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../models/driver_profile.dart';

class InvalidOtpException implements Exception {}

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
}

class ApiAuthRepositoryImpl implements AuthRepository {
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
      return DriverProfile.fromJson(data['driver'] as Map<String, dynamic>);
    } on ApiException catch (e) {
      if (e.statusCode == 422) throw InvalidOtpException();
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
    return GoogleLoginResult(driver: driver, phoneLinked: data['phone_linked'] as bool);
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
      return DriverProfile.fromJson(data);
    } on ApiException catch (e) {
      if (e.statusCode == 422) throw InvalidOtpException();
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
