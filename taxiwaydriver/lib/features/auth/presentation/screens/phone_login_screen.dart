import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/driver_profile.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../../core/services/phone_hint_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/state/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../core/widgets/phone_input.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool _googleLoading = false;
  String _phone = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted && _phone.isEmpty) {
          _promptSimAutoDetect();
        }
      });
    });
  }

  Future<void> _promptSimAutoDetect() async {
    final detected = await PhoneHintService.requestPhoneNumber(context);
    if (detected != null && mounted) {
      setState(() {
        _phone = detected;
        _controller.text = detected;
        _error = null;
      });
      AppToast.success(context, 'Driver number +91 $detected auto-filled', title: 'SIM Detected');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid => _phone.length == 10;

  Future<void> _continue() async {
    if (!_isValid || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final debugOtp = await ref.read(authControllerProvider.notifier).sendOtp(_phone);
      if (!mounted) return;
      if (debugOtp != null) {
        AppToast.info(context, 'OTP: $debugOtp', title: 'Dev Mode — No SMS Gateway');
      }
      context.push(AppRoutes.otp);
    } catch (_) {
      if (!mounted) return;
      const msg = "Couldn't send OTP. Please try again.";
      setState(() => _error = msg);
      AppToast.error(context, msg, title: 'SMS Error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _continueWithGoogle() async {
    if (_googleLoading) return;
    setState(() => _googleLoading = true);
    try {
      final idToken = await GoogleAuthService.signIn();
      final phoneLinked = await ref.read(authControllerProvider.notifier).loginWithGoogle(idToken);
      if (!mounted) return;
      if (phoneLinked) {
        PushNotificationService.initialize(ref);
        final driver = ref.read(authControllerProvider).driver;
        if (driver?.verificationStatus == VerificationStatus.verified) {
          context.go(AppRoutes.dashboard);
        } else {
          context.go(AppRoutes.verificationStatus);
        }
      } else {
        AppToast.info(context, 'Add your phone number to finish setting up your account.', title: 'Almost there');
      }
    } on GoogleSignInCancelledException {
      // User dismissed the picker — nothing to report.
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, "Couldn't sign in with Google. Please try again.", title: 'Sign-In Error');
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.of(context).card,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),

                      // Top App Bar with Back Button and Centered Title
                      Row(
                        children: [
                          AppBackButton(
                            onPressed: () => context.canPop() ? context.pop() : null,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Login',
                                style: AppTypography.of(context).h3.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.of(context).navy,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 38), // Balances the 38px back button for true centering
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Top Section Image
                      Center(
                        child: Image.asset(
                          'assets/images/login_home.png',
                          height: 180,
                          fit: BoxFit.contain,
                        )
                            .animate()
                            .scale(
                              duration: 450.ms,
                              curve: Curves.easeOutBack,
                              begin: const Offset(0.85, 0.85),
                              end: const Offset(1, 1),
                            )
                            .fadeIn(duration: 300.ms),
                      ),

                      const SizedBox(height: 24),

                      Text(l10n.driverLoginTitle, style: AppTypography.of(context).h1)
                          .animate()
                          .fadeIn(delay: 150.ms, duration: 350.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      PhoneInput(
                        controller: _controller,
                        onChanged: (v) => setState(() {
                          _phone = v;
                          _error = null;
                        }),
                        onSimPickerTap: _promptSimAutoDetect,
                      ).animate().fadeIn(delay: 250.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.of(context).errorBackground,
                            borderRadius: BorderRadius.circular(AppRadius.medium),
                            border: Border.all(color: AppColors.of(context).errorBorder),
                          ),
                          child: Text(
                            _error!,
                            style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).error, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],

                      const Spacer(),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isValid ? _continue : null,
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                              : Text(l10n.continueLabel),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const OrDivider().animate().fadeIn(delay: 350.ms, duration: 350.ms),

                      const SizedBox(height: 20),

                      GoogleSignInButton(onPressed: _continueWithGoogle, loading: _googleLoading)
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 350.ms),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
