import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';
import 'network_error_view.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.of(context).surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppColors.of(context).mutedText),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.of(context).h3.copyWith(
                color: AppColors.of(context).navy,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                message,
                style: AppTypography.of(context).body.copyWith(
                  color: AppColors.of(context).bodyText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: PrimaryButton(label: actionLabel!, onPressed: onAction),
              ),
            ],
          ],
        ),
      ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04, end: 0, duration: 260.ms, curve: Curves.easeOutCubic),
    );
  }
}

class ErrorState extends StatelessWidget {
  final Object? error;
  final String? message;
  final VoidCallback onRetry;
  final bool isCompact;

  const ErrorState({
    super.key,
    this.error,
    this.message,
    required this.onRetry,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return NetworkErrorView(
      type: error == null ? NetworkErrorType.generic : networkErrorTypeFor(error!),
      message: message,
      onRetry: () async => onRetry(),
      isCompact: isCompact,
    );
  }
}
