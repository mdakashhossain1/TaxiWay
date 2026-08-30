import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/theme_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../theme/eased_circle_clipper.dart';
import 'language_picker_sheet.dart';

/// Pass [lightMode] = true to render on dark backgrounds (white text).
class TaxiwayWordmark extends StatelessWidget {
  final double fontSize;
  final bool lightMode;
  const TaxiwayWordmark({super.key, this.fontSize = 22, this.lightMode = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Taxiway',
      style: AppTypography.of(context).h2.copyWith(
        fontSize: fontSize,
        color: lightMode ? Colors.white : AppColors.of(context).navy,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const TaxiwayWordmark(fontSize: 26),
              const SizedBox(height: 2),
              Text(
                'Safe. Reliable. Anytime.',
                style: AppTypography.of(context).caption.copyWith(
                  color: AppColors.of(context).mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Consumer(
                builder: (context, ref, _) => ThemeSwitcher.withTheme(
                  clipper: const EasedThemeSwitcherCircleClipper(),
                  builder: (context, switcher, theme) {
                    final isDark = theme.brightness == Brightness.dark;
                    return Material(
                      color: AppColors.of(context).card,
                      shape: const CircleBorder(),
                      elevation: 1.5,
                      shadowColor: Colors.black26,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          final newIsDark = !isDark;
                          switcher.changeTheme(theme: newIsDark ? AppTheme.dark : AppTheme.light);
                          ref.read(themeControllerProvider.notifier).setDark(newIsDark);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Icon(
                            isDark ? BootstrapIcons.moon_stars_fill : BootstrapIcons.sun_fill,
                            size: 20,
                            color: AppColors.of(context).navy,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Consumer(
                builder: (context, ref, _) => Material(
                  color: AppColors.of(context).card,
                  shape: const CircleBorder(),
                  elevation: 1.5,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => showLanguagePickerSheet(context, ref),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Icon(BootstrapIcons.translate, size: 20, color: AppColors.of(context).navy),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: AppColors.of(context).card,
                shape: const CircleBorder(),
                elevation: 1.5,
                shadowColor: Colors.black26,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onProfileTap,
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Icon(BootstrapIcons.person_fill, size: 20, color: AppColors.of(context).navy),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
