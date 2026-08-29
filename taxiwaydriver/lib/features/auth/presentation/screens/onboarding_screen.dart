import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/auth_hero_badge.dart';
import '../../../../core/widgets/auth_illustrations.dart';
import '../../../../core/widgets/taxiway_header.dart';
import '../../../../l10n/generated/app_localizations.dart';

class _DriverOnboardingSlide {
  final Widget illustration;
  final String title;
  final String subtitle;
  final Color accent;

  const _DriverOnboardingSlide({
    required this.illustration,
    required this.title,
    required this.subtitle,
    required this.accent,
  });
}

class DriverOnboardingScreen extends ConsumerStatefulWidget {
  const DriverOnboardingScreen({super.key});

  @override
  ConsumerState<DriverOnboardingScreen> createState() => _DriverOnboardingScreenState();
}

class _DriverOnboardingScreenState extends ConsumerState<DriverOnboardingScreen> {
  static const _storage = FlutterSecureStorage();
  static const _onboardingKey = 'driver_onboarding_seen';

  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await _storage.write(key: _onboardingKey, value: 'true');
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  void _next(int totalSlides) {
    if (_currentPage < totalSlides - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  List<_DriverOnboardingSlide> _buildSlides() {
    return [
      _DriverOnboardingSlide(
        illustration: const AuthHeroBadge(
          icon: BootstrapIcons.car_front_fill,
          color: AppColors.primary,
          size: 110,
          badgeIcon: BootstrapIcons.cash_coin,
          badgeColor: Color(0xFF16A34A),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut)
            .animate()
            .scale(duration: 500.ms, curve: Curves.easeOutBack, begin: const Offset(0.7, 0.7))
            .fadeIn(duration: 350.ms),
        title: 'Drive & Earn in Patna',
        subtitle: 'Earn reliable daily income with direct payouts, guaranteed ride requests, and 0% commission.',
        accent: AppColors.primary,
      ),
      _DriverOnboardingSlide(
        illustration: const OtpHeroIllustration(size: 140)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut)
            .animate()
            .scale(duration: 500.ms, curve: Curves.easeOutBack, begin: const Offset(0.7, 0.7))
            .fadeIn(duration: 350.ms),
        title: 'Safe & Verified Trips',
        subtitle: 'Every passenger is phone-verified with accurate pickup routes and 24/7 SOS safety support.',
        accent: const Color(0xFF6366F1),
      ),
      _DriverOnboardingSlide(
        illustration: const PhoneAuthHeroIllustration(size: 140)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -6, duration: 1800.ms, curve: Curves.easeInOut)
            .animate()
            .scale(duration: 500.ms, curve: Curves.easeOutBack, begin: const Offset(0.7, 0.7))
            .fadeIn(duration: 350.ms),
        title: 'Flexible Subscriptions',
        subtitle: 'Choose affordable daily or weekly plans. Keep 100% of your earnings with no hidden deductions.',
        accent: const Color(0xFF0D9488),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _buildSlides();
    final isLast = _currentPage == slides.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with logo and skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TaxiwayWordmark(fontSize: 24),
                  if (!isLast)
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        'Skip',
                        style: AppTypography.body.copyWith(
                          color: AppColors.secondaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Slide content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final s = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Illustration Container
                        Center(child: s.illustration),

                        const SizedBox(height: 36),

                        // Title
                        Text(
                          s.title,
                          style: AppTypography.h1.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('title_$index'))
                            .fadeIn(delay: 150.ms, duration: 350.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          s.subtitle,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.bodyText,
                            height: 1.5,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('sub_$index'))
                            .fadeIn(delay: 250.ms, duration: 350.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom: Dots + Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // Primary action button
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _next(slides.length),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                        textStyle: AppTypography.button,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isLast ? 'Get Started' : l10n.continueLabel),
                          const SizedBox(width: 8),
                          Icon(
                            isLast ? BootstrapIcons.arrow_right : BootstrapIcons.chevron_right,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isLast) ...[
                    const SizedBox(height: 12),
                    // Already registered? Login
                    SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _finish,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.button),
                          ),
                          textStyle: AppTypography.button.copyWith(color: AppColors.primary),
                        ),
                        child: Text(l10n.loginLabel),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
