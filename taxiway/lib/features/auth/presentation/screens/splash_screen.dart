import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/auth_controller.dart';

/// Pure splash screen — full-screen brand image, shown for ~2.5 seconds.
/// No buttons, no overlays. Navigates automatically based on auth state.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _storage = FlutterSecureStorage();
  static const _onboardingKey = 'onboarding_seen';

  bool _minTimeElapsed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      setState(() => _minTimeElapsed = true);
      _navigate();
    });
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final status = ref.read(authControllerProvider).status;

    // Still loading auth state — wait for it via the listener below
    if (status == AuthStatus.checking) return;

    if (status == AuthStatus.authenticated) {
      context.go(AppRoutes.home);
      return;
    }

    // Check if onboarding has been seen before
    final seen = await _storage.read(key: _onboardingKey);
    if (!mounted) return;

    if (seen == null) {
      // First-time user → show onboarding carousel
      context.go(AppRoutes.onboarding);
    } else {
      // Returning user → go straight to login
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state resolution during the wait period
    ref.listen(authControllerProvider, (previous, next) {
      if (_minTimeElapsed) _navigate();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFDE8D8),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash_bg.png',
          fit: BoxFit.cover,
        )
            .animate()
            .fadeIn(duration: 400.ms),
      ),
    );
  }
}
