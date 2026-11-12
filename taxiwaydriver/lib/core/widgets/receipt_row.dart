import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool emphasized;

  const ReceiptRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasized
        ? AppTypography.of(context).label.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.of(context).navy,
            )
        : AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w600);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Text(label, style: AppTypography.of(context).caption)),
              const SizedBox(width: 12),
              Flexible(child: Text(value, style: valueStyle, textAlign: TextAlign.end)),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
