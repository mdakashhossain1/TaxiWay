import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../models/customer.dart';

enum AuthStatus { checking, unauthenticated, otpSent, authenticated }

class AuthState {
  final AuthStatus status;
  final String phone;
  final Customer? customer;
  final bool isNewCustomer;
  final String? debugOtp;

  /// True right after a Google sign-in whose account has no phone on file
  /// yet. While true, the phone/OTP screens attach a phone number to the
  /// already-authenticated Google session instead of starting a fresh login.
  final bool linking;

  const AuthState({
    this.status = AuthStatus.checking,
    this.phone = '',
    this.customer,
    this.isNewCustomer = false,
    this.debugOtp,
    this.linking = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? phone,
    Customer? customer,
    bool? isNewCustomer,
    String? debugOtp,
    bool? linking,
  }) {
    return AuthState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      customer: customer ?? this.customer,
      isNewCustomer: isNewCustomer ?? this.isNewCustomer,
      debugOtp: debugOtp ?? this.debugOtp,
      linking: linking ?? this.linking,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  final AuthRepository _repo;
  AuthController(this._repo);

  @override
  AuthState build() {
    _checkSession();
    return const AuthState();
  }

  Future<void> _checkSession() async {
    final customer = await _repo.getSession();
    if (customer != null) {
      state = AuthState(status: AuthStatus.authenticated, customer: customer, phone: customer.phone);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<String?> sendOtp(String phone) async {
    final debugOtp = state.linking ? await _repo.sendPhoneLinkOtp(phone) : await _repo.sendOtp(phone);
    state = state.copyWith(status: AuthStatus.otpSent, phone: phone, debugOtp: debugOtp);
    return debugOtp;
  }

  Future<void> verifyOtp(String otp) async {
    if (state.linking) {
      final customer = await _repo.confirmPhoneLink(state.phone, otp);
      state = AuthState(status: AuthStatus.authenticated, customer: customer, phone: state.phone);
      return;
    }

    final result = await _repo.verifyOtp(state.phone, otp);
    state = AuthState(
      status: AuthStatus.authenticated,
      customer: result.customer,
      phone: state.phone,
      isNewCustomer: result.isNewCustomer,
    );
  }

  /// Signs in with a Firebase ID token obtained via [GoogleAuthService].
  /// Returns whether the account already has a phone linked — false means
  /// the caller should collect one through the normal phone/OTP screens,
  /// which [sendOtp]/[verifyOtp] now handle in "linking" mode.
  Future<bool> loginWithGoogle(String idToken) async {
    final result = await _repo.loginWithGoogle(idToken);
    state = AuthState(
      status: result.phoneLinked ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      customer: result.customer,
      phone: result.customer.phone,
      linking: !result.phoneLinked,
    );
    return result.phoneLinked;
  }

  Future<void> completeProfile({required String name, String? email}) async {
    final updated = state.customer!.copyWith(name: name, email: email);
    await _repo.saveSession(updated);
    state = state.copyWith(customer: updated, isNewCustomer: false);
  }

  Future<void> logout() async {
    await _repo.clearSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
