import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../models/customer.dart';

class InvalidOtpException implements Exception {}

class AuthResult {
  final Customer customer;
  final bool isNewCustomer;
  const AuthResult({required this.customer, required this.isNewCustomer});
}

class GoogleLoginResult {
  final Customer customer;
  final bool phoneLinked;
  const GoogleLoginResult({required this.customer, required this.phoneLinked});
}

abstract class AuthRepository {
  /// Returns the OTP code when the backend echoes one back (non-production
  /// builds only, since no SMS gateway is wired up), otherwise null.
  Future<String?> sendOtp(String phone);
  Future<AuthResult> verifyOtp(String phone, String otp);
  Future<GoogleLoginResult> loginWithGoogle(String idToken);
  Future<String?> sendPhoneLinkOtp(String phone);
  Future<Customer> confirmPhoneLink(String phone, String otp);
  Future<void> registerDeviceToken(String fcmToken);
  Future<void> saveSession(Customer customer);
  Future<Customer?> getSession();
  Future<void> clearSession();
}

/// Real backend-backed implementation. The API only knows customers by
/// phone/name/email — there's no "get my profile" endpoint, so once
/// verify-otp/profile-update tell us who the customer is, we cache that
/// alongside the Sanctum token so app relaunches can skip login without a
/// network round trip.
class ApiAuthRepository implements AuthRepository {
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> sendOtp(String phone) async {
    final response = await ApiClient.instance.post('/customer/auth/send-otp', body: {'phone': phone}, auth: false);
    return response['debug_otp'] as String?;
  }

  @override
  Future<AuthResult> verifyOtp(String phone, String otp) async {
    try {
      final response = await ApiClient.instance.post(
        '/customer/auth/verify-otp',
        body: {'phone': phone, 'code': otp},
        auth: false,
      );
      final data = response['data'] as Map<String, dynamic>;
      await ApiClient.instance.saveToken(data['token'] as String);

      final customerJson = data['customer'] as Map<String, dynamic>;
      final isNew = data['is_new_customer'] as bool;
      final customer = Customer(
        id: customerJson['id'].toString(),
        name: isNew ? '' : customerJson['name'] as String,
        phone: customerJson['phone'] as String,
        email: customerJson['email'] as String?,
      );

      if (!isNew) await saveSession(customer);

      return AuthResult(customer: customer, isNewCustomer: isNew);
    } on ApiException catch (e) {
      if (e.statusCode == 422) throw InvalidOtpException();
      rethrow;
    }
  }

  @override
  Future<GoogleLoginResult> loginWithGoogle(String idToken) async {
    final response = await ApiClient.instance.post(
      '/customer/auth/google',
      body: {'id_token': idToken},
      auth: false,
    );
    final data = response['data'] as Map<String, dynamic>;
    await ApiClient.instance.saveToken(data['token'] as String);

    final customerJson = data['customer'] as Map<String, dynamic>;
    final phoneLinked = data['phone_linked'] as bool;
    final customer = Customer(
      id: customerJson['id'].toString(),
      name: customerJson['name'] as String,
      phone: customerJson['phone'] as String? ?? '',
      email: customerJson['email'] as String?,
      photoUrl: customerJson['photo_url'] as String?,
    );

    if (phoneLinked) await saveSession(customer);

    return GoogleLoginResult(customer: customer, phoneLinked: phoneLinked);
  }

  @override
  Future<String?> sendPhoneLinkOtp(String phone) async {
    final response = await ApiClient.instance.post('/customer/auth/phone/send-otp', body: {'phone': phone});
    return response['debug_otp'] as String?;
  }

  @override
  Future<Customer> confirmPhoneLink(String phone, String otp) async {
    try {
      final response = await ApiClient.instance.post(
        '/customer/auth/phone/verify',
        body: {'phone': phone, 'code': otp},
      );
      final customerJson = (response['data'] as Map<String, dynamic>)['customer'] as Map<String, dynamic>;
      final customer = Customer(
        id: customerJson['id'].toString(),
        name: customerJson['name'] as String,
        phone: customerJson['phone'] as String,
        email: customerJson['email'] as String?,
        photoUrl: customerJson['photo_url'] as String?,
      );
      await saveSession(customer);
      return customer;
    } on ApiException catch (e) {
      if (e.statusCode == 422) throw InvalidOtpException();
      rethrow;
    }
  }

  @override
  Future<void> registerDeviceToken(String fcmToken) async {
    try {
      await ApiClient.instance.post('/customer/device-token', body: {'fcm_token': fcmToken});
    } on ApiException {
      // Non-fatal — pushes just won't reach this device until the next
      // successful registration attempt (e.g. next app launch/token refresh).
    }
  }

  @override
  Future<void> saveSession(Customer customer) async {
    await _storage.write(key: 'session_phone', value: customer.phone);
    await _storage.write(key: 'customer_id_${customer.phone}', value: customer.id);
    await _storage.write(key: 'customer_name_${customer.phone}', value: customer.name);
    if (customer.email != null) {
      await _storage.write(key: 'customer_email_${customer.phone}', value: customer.email);
    }

    // Complete registration server-side too, if there's anything to save.
    if (customer.name.isNotEmpty) {
      try {
        await ApiClient.instance.patch('/customer/profile', body: {
          'name': customer.name,
          if (customer.email != null) 'email': customer.email,
        });
      } on ApiException {
        // Non-fatal — the local session is still valid; profile sync can
        // retry next time saveSession runs.
      }
    }
  }

  @override
  Future<Customer?> getSession() async {
    final token = await ApiClient.instance.readToken();
    final phone = await _storage.read(key: 'session_phone');
    if (token == null || phone == null) return null;

    final name = await _storage.read(key: 'customer_name_$phone') ?? '';
    if (name.isEmpty) return null;

    final id = await _storage.read(key: 'customer_id_$phone') ?? phone;
    final email = await _storage.read(key: 'customer_email_$phone');
    return Customer(id: id, name: name, phone: phone, email: email);
  }

  @override
  Future<void> clearSession() async {
    final phone = await _storage.read(key: 'session_phone');
    await ApiClient.instance.clearToken();
    await _storage.delete(key: 'session_phone');
    if (phone != null) {
      await _storage.delete(key: 'customer_id_$phone');
      await _storage.delete(key: 'customer_name_$phone');
      await _storage.delete(key: 'customer_email_$phone');
    }
  }
}
