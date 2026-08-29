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
import '../../../../core/widgets/taxiway_header.dart';
import '../../../../l10n/generated/app_localizations.dart';

class _Slide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _Slide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });
}

const _slides = [
  _Slide(
    icon: BootstrapIcons.geo_alt_fill,
    title: 'Ride Anywhere in Patna',
    subtitle: 'Book a cab to any destination instantly — airport, station, or your favourite spot.',
    accent: AppColors.primary,
  ),
  _Slide(
    icon: BootstrapIcons.shield_check,
    title: 'Safe & Verified Drivers',
    subtitle: 'Every driver is background-checked and rated by riders like you, for your peace of mind.',
    accent: Color(0xFF6366F1),
  ),
  _Slide(
    icon: BootstrapIcons.cash_coin,
    title: 'Transparent Pricing',
    subtitle: 'No surge pricing surprises. See the full fare breakdown before you book.',
    accent: Color(0xFF16A34A),
  ),
];

/// Onboarding carousel — shown only once, to first-time users.
/// After tapping "Get Started", marks onboarding as seen and goes to Login.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _storage = FlutterSecureStorage();
  static const _onboardingKey = 'onboarding_seen';

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

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLast = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.appBackground,
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
                        style: AppTypography.body.copyWith(color: AppColors.secondaryText),
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
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final s = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon circle
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: s.accent.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(s.icon, size: 54, color: s.accent),
                        )
                            .animate(key: ValueKey(index))
                            .scale(duration: 450.ms, curve: Curves.elasticOut, begin: const Offset(0.4, 0.4))
                            .fadeIn(duration: 300.ms),

                        const SizedBox(height: 40),

                        // Title
                        Text(
                          s.title,
                          style: AppTypography.h1.copyWith(fontSize: 26),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('t$index'))
                            .fadeIn(delay: 150.ms, duration: 350.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 14),

                        // Subtitle
                        Text(
                          s.subtitle,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.secondaryText,
                            height: 1.55,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('s$index'))
                            .fadeIn(delay: 250.ms, duration: 350.ms)
                            .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom: Dots + Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // Primary action button
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
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
                          Text(isLast ? l10n.getStarted : 'Next'),
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
                    // Already have account
                    SizedBox(
                      height: 54,
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
                        child: Text(l10n.login),
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
