import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/language_picker_sheet.dart';
import '../../../../core/utils/legal_links.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ProfileMenuScreen extends ConsumerWidget {
  const ProfileMenuScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Text(l10n.logout, style: AppTypography.of(context).h3.copyWith(color: AppColors.of(context).navy)),
        content: Text(l10n.logoutConfirmBody, style: AppTypography.of(context).body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel, style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).mutedText)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context).error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).logout();
      if (context.mounted) context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final customer = ref.watch(authControllerProvider).customer;

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          l10n.profileTitle,
          style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy),
        ),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),

          // Customer Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(BootstrapIcons.person_fill, size: 28, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer?.name ?? l10n.guest,
                        style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(BootstrapIcons.telephone, size: 12, color: AppColors.of(context).primary),
                          const SizedBox(width: 4),
                          Text(
                            '+91 ${customer?.phone ?? ''}',
                            style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).bodyText, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Menu Options
          _MenuSection(
            children: [
              _MenuTile(
                icon: BootstrapIcons.receipt,
                label: l10n.myTrips,
                onTap: () => context.push(AppRoutes.tripHistory),
              ),
              _MenuTile(
                icon: BootstrapIcons.headset,
                label: l10n.helpSupport,
                onTap: () => context.push(AppRoutes.helpSupport),
              ),
              _MenuTile(
                icon: BootstrapIcons.translate,
                label: l10n.languageMenuItem,
                onTap: () => showLanguagePickerSheet(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _MenuSection(
            children: [
              _MenuTile(
                icon: BootstrapIcons.file_text,
                label: l10n.termsAndConditions,
                onTap: () => openInAppBrowser(kTermsAndConditionsUrl),
              ),
              _MenuTile(
                icon: BootstrapIcons.shield_lock_fill,
                label: l10n.privacyPolicy,
                onTap: () => openInAppBrowser(kPrivacyPolicyUrl),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _MenuSection(
            children: [
              _MenuTile(
                icon: BootstrapIcons.box_arrow_right,
                label: l10n.logout,
                destructive: true,
                onTap: () => _logout(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<Widget> children;
  const _MenuSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).border),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const _MenuTile({required this.icon, required this.label, required this.onTap, this.destructive = false});

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.of(context).error : AppColors.of(context).navy;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.of(context).bodyLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            if (!destructive) Icon(BootstrapIcons.chevron_right, size: 14, color: AppColors.of(context).mutedText),
          ],
        ),
      ),
    );
  }
}
