import 'dart:async';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/otp_autoread_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/edit_phone_bottom_sheet.dart';
import '../../../../core/widgets/otp_input.dart';
import '../../../../l10n/generated/app_localizations.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpKey = GlobalKey<OtpInputState>();
  String _code = '';
  bool _verifying = false;
  String? _error;
  int _secondsLeft = 28;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _listenForOtp();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoFillDebugOtp());
  }

  /// The backend only echoes an OTP back when the SMS gateway is in debug
  /// mode (Settings > SMS Gateway, Live Mode off) — auto-fill from it so
  /// testing never requires manual entry. In live mode this is null and the
  /// real SMS is picked up by the consent listener below instead.
  void _autoFillDebugOtp() {
    final debugOtp = ref.read(authControllerProvider).debugOtp;
    if (debugOtp != null) _otpKey.currentState?.setCode(debugOtp);
  }

  /// Waits for the real OTP SMS (live mode) and auto-fills the boxes once it arrives.
  Future<void> _listenForOtp() async {
    final code = await OtpAutoReadService.listen();
    if (!mounted || code == null) return;
    _otpKey.currentState?.setCode(code);
  }

  void _startCountdown() {
    _secondsLeft = 28;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        setState(() => _secondsLeft = 0);
        t.cancel();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    OtpAutoReadService.cancel();
    super.dispose();
  }

  Future<void> _verify(String code) async {
    setState(() {
      _code = code;
      _verifying = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).verifyOtp(code);
      if (!mounted) return;
      AppToast.success(context, 'Phone verified successfully!', title: 'Welcome');
      PushNotificationService.initialize(ref);
      final authState = ref.read(authControllerProvider);
      if (authState.isNewCustomer) {
        context.go(AppRoutes.profileSetup);
      } else {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (!mounted) return;
      final msg = AppLocalizations.of(context).invalidOtp;
      setState(() => _error = msg);
      AppToast.error(context, msg, title: 'Incorrect OTP');
      await _otpKey.currentState?.shakeAndClear();
      if (!mounted) return;
      setState(() => _code = '');
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    final phone = ref.read(authControllerProvider).phone;
    final debugOtp = await ref.read(authControllerProvider.notifier).sendOtp(phone);
    _startCountdown();
    _listenForOtp();
    if (!mounted) return;
    if (debugOtp != null) {
      _otpKey.currentState?.setCode(debugOtp);
      AppToast.info(context, 'OTP: $debugOtp', title: 'Dev Mode — No SMS Gateway');
    } else {
      AppToast.info(context, AppLocalizations.of(context).otpResent, title: 'Code Resent');
    }
  }

  Future<void> _openChangePhoneSheet() async {
    final currentPhone = ref.read(authControllerProvider).phone;
    String? debugOtp;
    final newPhone = await EditPhoneBottomSheet.show(
      context,
      currentPhone: currentPhone,
      onConfirm: (phone) async {
        debugOtp = await ref.read(authControllerProvider.notifier).sendOtp(phone);
      },
    );

    if (newPhone != null && mounted) {
      _startCountdown();
      _listenForOtp();
      setState(() {
        _code = '';
        _error = null;
      });
      if (debugOtp != null) {
        _otpKey.currentState?.setCode(debugOtp!);
        AppToast.info(context, 'OTP: $debugOtp', title: 'Dev Mode — No SMS Gateway');
        return;
      }
      AppToast.success(
        context,
        'New OTP sent to +91 $newPhone',
        title: 'Number Updated',
      );
    }
  }

  String _maskedPhone(String raw) {
    final clean = raw.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 10) {
      return '${clean.substring(0, 2)}*****${clean.substring(7)}';
    } else if (clean.length >= 6) {
      return '${clean.substring(0, 2)}****${clean.substring(clean.length - 2)}';
    }
    return clean.isEmpty ? '98*****210' : clean;
  }

  @override
  Widget build(BuildContext context) {
    final phone = ref.watch(authControllerProvider).phone;
    final displayPhone = _maskedPhone(phone);
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
                            onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.login),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'OTP Verification',
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
                          'assets/images/otp_hero.png',
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

                      // Heading: Verify your number
                      Text(
                        l10n.verifyYourNumber,
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

                      Text(
                        "We've sent a 6-digit OTP to",
                        style: AppTypography.of(context).body.copyWith(
                          fontSize: 15,
                          color: AppColors.of(context).bodyText,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 180.ms, duration: 350.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      // Interactive Phone Number Badge with "Change" button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.of(context).border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(BootstrapIcons.phone_fill, size: 14, color: AppColors.of(context).primary),
                            const SizedBox(width: 8),
                            Text(
                              '+91 $displayPhone',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.of(context).navy,
                                fontSize: 15,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: _openChangePhoneSheet,
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.of(context).primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(BootstrapIcons.pencil_square, size: 12, color: AppColors.of(context).primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Change',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.of(context).primary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 210.ms, duration: 350.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // 6 OTP Input Boxes
                      OtpInput(
                        key: _otpKey,
                        onChanged: (code) => setState(() => _code = code),
                        onCompleted: _verify,
                      ).animate().fadeIn(delay: 250.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            _error!,
                            style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).error, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],

                      const SizedBox(height: 18),

                      // Upper Section: Sleek Inline Resend Option / Pill
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: _secondsLeft == 0
                                ? AppColors.of(context).primary.withValues(alpha: 0.08)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _secondsLeft == 0
                                  ? AppColors.of(context).primary.withValues(alpha: 0.35)
                                  : const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: _secondsLeft > 0
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(BootstrapIcons.clock_history, size: 13, color: AppColors.of(context).secondaryText),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Resend OTP in ',
                                      style: AppTypography.of(context).caption.copyWith(
                                        color: AppColors.of(context).bodyText,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '00:${_secondsLeft.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: AppColors.of(context).primaryDark,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: _resend,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(BootstrapIcons.arrow_clockwise, size: 14, color: AppColors.of(context).primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Didn't receive code? ",
                                        style: AppTypography.of(context).caption.copyWith(
                                          color: AppColors.of(context).bodyText,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        l10n.resendOtp,
                                        style: TextStyle(
                                          color: AppColors.of(context).primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.5,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ).animate().fadeIn(delay: 280.ms, duration: 300.ms),

                      const Spacer(),

                      const SizedBox(height: 16),

                      // Single Clean Primary CTA: "Verify & Continue"
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _code.length == 6 && !_verifying ? () => _verify(_code) : null,
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
                          child: _verifying
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                              : Text(l10n.verifyAndContinue),
                        ),
                      ),

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
