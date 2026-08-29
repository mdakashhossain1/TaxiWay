import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../data/auth_repository.dart';
import '../models/driver_profile.dart';

class AuthState {
  final String phone;
  final DriverProfile? driver;
  final String? debugOtp;

  /// True right after a Google sign-in whose account has no phone on file
  /// yet. While true, the phone/OTP screens attach a phone number to the
  /// already-authenticated Google session instead of starting a fresh login.
  final bool linking;

  const AuthState({this.phone = '', this.driver, this.debugOtp, this.linking = false});

  bool get isLoggedIn => driver != null;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<String?> sendOtp(String phone) async {
    state = AuthState(phone: phone, driver: state.driver, linking: state.linking);
    final debugOtp = state.linking
        ? await ref.read(authRepositoryProvider).sendPhoneLinkOtp(phone)
        : await ref.read(authRepositoryProvider).sendOtp(phone);
    state = AuthState(phone: phone, driver: state.driver, debugOtp: debugOtp, linking: state.linking);
    return debugOtp;
  }

  Future<void> verifyOtp(String code) async {
    if (state.linking) {
      final driver = await ref.read(authRepositoryProvider).confirmPhoneLink(state.phone, code);
      state = AuthState(phone: state.phone, driver: driver);
      return;
    }

    final driver = await ref.read(authRepositoryProvider).verifyOtp(state.phone, code);
    state = AuthState(phone: state.phone, driver: driver);
  }

  /// Signs in with a Firebase ID token obtained via [GoogleAuthService].
  /// Returns whether the account already has a phone linked — false means
  /// the caller should collect one through the normal phone/OTP screens,
  /// which [sendOtp]/[verifyOtp] now handle in "linking" mode.
  Future<bool> loginWithGoogle(String idToken) async {
    final result = await ref.read(authRepositoryProvider).loginWithGoogle(idToken);
    state = AuthState(
      phone: result.driver.phone,
      driver: result.phoneLinked ? result.driver : null,
      linking: !result.phoneLinked,
    );
    return result.phoneLinked;
  }

  void logout() {
    ApiClient.instance.clearToken();
    state = const AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
