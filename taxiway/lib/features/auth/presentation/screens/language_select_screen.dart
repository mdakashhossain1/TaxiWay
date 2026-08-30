import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/auth_hero_badge.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/language_tile.dart';

/// Shown once, before the onboarding carousel — the very first thing a new
/// user sees. Returning users who've already picked a language skip straight
/// past this to the splash/onboarding flow.
class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  Locale? _selected;
  bool _navigated = false;

  void _goToSplash() {
    if (_navigated) return;
    _navigated = true;
    context.go(AppRoutes.splash);
  }

  Future<void> _confirm() async {
    final locale = _selected ?? kSupportedLocales.first;
    await ref.read(localeControllerProvider.notifier).setLocale(locale);
    if (!mounted) return;
    _goToSplash();
  }

  @override
  Widget build(BuildContext context) {
    final localeState = ref.watch(localeControllerProvider);

    if (localeState.loading) {
      return Scaffold(backgroundColor: AppColors.of(context).appBackground, body: const SizedBox.shrink());
    }
    if (localeState.hasChosen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goToSplash());
      return Scaffold(backgroundColor: AppColors.of(context).appBackground, body: const SizedBox.shrink());
    }

    final l10n = AppLocalizations.of(context);
    _selected ??= kSupportedLocales.first;

    return Scaffold(
      backgroundColor: AppColors.of(context).appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const AuthHeroBadge(icon: BootstrapIcons.translate, size: 104)
                  .animate()
                  .scale(duration: 450.ms, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: 28),
              Text(l10n.languagePickerTitle, style: AppTypography.of(context).h1, textAlign: TextAlign.center)
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 350.ms)
                  .slideY(begin: 0.25, end: 0),
              const SizedBox(height: 8),
              Text(l10n.languagePickerSubtitle, style: AppTypography.of(context).bodyLarge, textAlign: TextAlign.center)
                  .animate()
                  .fadeIn(delay: 220.ms, duration: 350.ms)
                  .slideY(begin: 0.25, end: 0),
              const SizedBox(height: 32),
              ...kSupportedLocales.map(
                (locale) => LanguageTile(
                  label: languageDisplayName(l10n, locale),
                  selected: _selected?.languageCode == locale.languageCode,
                  onTap: () => setState(() => _selected = locale),
                ),
              ).toList().animate(interval: 60.ms).fadeIn(delay: 300.ms, duration: 300.ms).slideY(begin: 0.2, end: 0),
              const Spacer(flex: 4),
              PrimaryButton(label: l10n.continueLabel, onPressed: _confirm),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
