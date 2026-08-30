import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/google_auth_service.dart';
import '../../../../core/services/phone_hint_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../core/widgets/phone_input.dart';
import '../../../../core/utils/legal_links.dart';
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
      });
      AppToast.success(context, 'Number +91 $detected auto-filled from SIM', title: 'SIM Auto-Fill');
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
    setState(() => _loading = true);
    try {
      final debugOtp = await ref.read(authControllerProvider.notifier).sendOtp(_phone);
      if (!mounted) return;
      if (debugOtp != null) {
        AppToast.info(context, 'OTP: $debugOtp', title: 'Dev Mode — No SMS Gateway');
      }
      context.push(AppRoutes.otp);
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, "Couldn't send OTP. Please check your network and try again.", title: 'SMS Error');
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
        context.go(AppRoutes.home);
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
      backgroundColor: AppColors.of(context).appBackground,
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
                            onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.splash),
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

                      // Heading: Welcome!
                      Text(
                        l10n.welcome,
                        style: AppTypography.of(context).h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.of(context).navy,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 150.ms, duration: 350.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        'Enter your phone number\nto continue',
                        style: AppTypography.of(context).body.copyWith(
                          fontSize: 15,
                          color: AppColors.of(context).bodyText,
                          height: 1.35,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 350.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // Phone Input Field with SIM picker action
                      PhoneInput(
                        controller: _controller,
                        onChanged: (v) => setState(() => _phone = v),
                        onSimPickerTap: _promptSimAutoDetect,
                      ).animate().fadeIn(delay: 250.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),

                      // Terms and Privacy disclaimer with lock icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(BootstrapIcons.lock, size: 14, color: AppColors.of(context).bodyText),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: AppTypography.of(context).caption.copyWith(
                                  color: AppColors.of(context).bodyText,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(text: l10n.agreeToTerms),
                                  TextSpan(
                                    text: l10n.termsAndConditions,
                                    style: TextStyle(
                                      color: AppColors.of(context).primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => openInAppBrowser(kTermsAndConditionsUrl),
                                  ),
                                  TextSpan(text: l10n.andWord),
                                  TextSpan(
                                    text: l10n.privacyPolicy,
                                    style: TextStyle(
                                      color: AppColors.of(context).primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => openInAppBrowser(kPrivacyPolicyUrl),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 300.ms, duration: 350.ms),

                      const Spacer(),

                      const SizedBox(height: 16),

                      // Primary CTA Button: "Continue  →"
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isValid ? _continue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.of(context).primary,
                            disabledBackgroundColor: AppColors.of(context).primary.withValues(alpha: 0.4),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white70,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            textStyle: AppTypography.of(context).button,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(l10n.continueLabel),
                                    const SizedBox(width: 8),
                                    const Icon(BootstrapIcons.arrow_right, size: 18),
                                  ],
                                ),
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
