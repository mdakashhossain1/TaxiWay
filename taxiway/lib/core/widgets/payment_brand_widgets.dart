import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Official NPCI UPI Logo Asset Widget.
class UpiLogoWidget extends StatelessWidget {
  final double height;

  const UpiLogoWidget({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/upi_logo.png',
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(BootstrapIcons.qr_code, size: 16, color: Color(0xFF00B9F1)),
          const SizedBox(width: 4),
          Text(
            'UPI',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: height * 0.85,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

/// Real Cash Banknote Badge
class CashLogoWidget extends StatelessWidget {
  final double size;
  const CashLogoWidget({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF86EFAC), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(BootstrapIcons.cash_stack, size: 15, color: Color(0xFF15803D)),
          const SizedBox(width: 4),
          Text(
            '₹ CASH',
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF15803D),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Real Card (Visa / MasterCard / RuPay) Badge
class CardBrandLogoWidget extends StatelessWidget {
  final double height;
  const CardBrandLogoWidget({super.key, this.height = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Text(
            'VISA',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFEA580C),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Text(
            'RuPay',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Upgraded Payment Method Option Card
class ModernPaymentOptionTile extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final Widget logo;
  final bool selected;
  final VoidCallback onTap;

  const ModernPaymentOptionTile({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.logo,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.of(context).primaryBackground : AppColors.of(context).card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: selected ? AppColors.of(context).primary : AppColors.of(context).border,
            width: selected ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.of(context).primary.withValues(alpha: 0.10)
                  : const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Brand Logo Box
            Container(
              constraints: const BoxConstraints(minWidth: 46, minHeight: 34),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              alignment: Alignment.center,
              child: logo,
            ),
            const SizedBox(width: 14),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.of(context).label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.of(context).caption.copyWith(
                      color: AppColors.of(context).bodyText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Selection Checkmark Circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.of(context).primary : AppColors.of(context).borderStrong,
                  width: 2,
                ),
                color: selected ? AppColors.of(context).primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
