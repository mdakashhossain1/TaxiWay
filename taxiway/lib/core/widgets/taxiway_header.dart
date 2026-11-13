import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/theme_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../theme/eased_circle_clipper.dart';
import 'language_picker_sheet.dart';
import 'pressable_scale.dart';
import '../../l10n/generated/app_localizations.dart';

class TaxiwayWordmark extends StatelessWidget {
  final double fontSize;
  final bool lightMode;
  const TaxiwayWordmark({super.key, this.fontSize = 22, this.lightMode = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final ink = lightMode ? Colors.white : colors.navy;
    final style = AppTypography.of(context).h2.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      color: ink,
    );

    return Text.rich(
      TextSpan(
        text: AppLocalizations.of(context).appTitle,
        style: style,
        children: [TextSpan(text: '.', style: style.copyWith(color: colors.accent))],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _HeaderIconButton({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return PressableScale(
      pressedScale: 0.92,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(color: filled ? colors.primary : colors.surface, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: filled ? colors.onPrimary : colors.navy),
        ),
      ),
    );
  }
}

class TaxiwayHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const TaxiwayHeader({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TaxiwayWordmark(fontSize: 28),
          Row(
            children: [
              Consumer(
                builder: (context, ref, _) => ThemeSwitcher.withTheme(
                  clipper: const EasedThemeSwitcherCircleClipper(),
                  builder: (context, switcher, theme) {
                    final isDark = theme.brightness == Brightness.dark;
                    return _HeaderIconButton(
                      icon: isDark ? AppIcons.moon_stars_fill : AppIcons.sun_fill,
                      onTap: () {
                        final newIsDark = !isDark;
                        switcher.changeTheme(theme: newIsDark ? AppTheme.dark : AppTheme.light);
                        ref.read(themeControllerProvider.notifier).setDark(newIsDark);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Consumer(
                builder: (context, ref, _) => _HeaderIconButton(
                  icon: AppIcons.translate,
                  onTap: () => showLanguagePickerSheet(context, ref),
                ),
              ),
              const SizedBox(width: 8),
              _HeaderIconButton(icon: AppIcons.person_fill, onTap: onProfileTap, filled: true),
            ],
          ),
        ],
      ),
    );
  }
}
