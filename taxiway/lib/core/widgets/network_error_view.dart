import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../l10n/generated/app_localizations.dart';
import '../api/api_client.dart';
import '../api/network_failure.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

enum NetworkErrorType {
  noInternet,
  serverError,
  timeout,
  maintenance,
  generic,
}

NetworkErrorType networkErrorTypeFor(Object error) {
  if (error is NetworkFailure) {
    return error.kind == NetworkFailureKind.timeout ? NetworkErrorType.timeout : NetworkErrorType.noInternet;
  }
  if (error is ApiException) {
    return error.statusCode >= 500 ? NetworkErrorType.serverError : NetworkErrorType.generic;
  }
  final text = error.toString().toLowerCase();
  if (text.contains('socket') || text.contains('connection')) return NetworkErrorType.noInternet;
  if (text.contains('timeout')) return NetworkErrorType.timeout;
  return NetworkErrorType.generic;
}

/// A premium, animated Error & Offline state view using the 3D illustration.
class NetworkErrorView extends StatefulWidget {
  final NetworkErrorType type;
  final String? title;
  final String? message;
  final Future<void> Function()? onRetry;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;
  final bool isCompact;

  const NetworkErrorView({
    super.key,
    this.type = NetworkErrorType.noInternet,
    this.title,
    this.message,
    this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionLabel,
    this.isCompact = false,
  });

  @override
  State<NetworkErrorView> createState() => _NetworkErrorViewState();
}

class _NetworkErrorViewState extends State<NetworkErrorView> {
  bool _isRetrying = false;

  String _titleFor(AppLocalizations l10n) {
    switch (widget.type) {
      case NetworkErrorType.noInternet:
        return l10n.errorOfflineTitle;
      case NetworkErrorType.serverError:
        return l10n.errorServerTitle;
      case NetworkErrorType.timeout:
        return l10n.errorTimeoutTitle;
      case NetworkErrorType.maintenance:
        return l10n.errorMaintenanceTitle;
      case NetworkErrorType.generic:
        return l10n.errorGenericTitle;
    }
  }

  String _messageFor(AppLocalizations l10n) {
    switch (widget.type) {
      case NetworkErrorType.noInternet:
        return l10n.errorOfflineMessage;
      case NetworkErrorType.serverError:
        return l10n.errorServerMessage;
      case NetworkErrorType.timeout:
        return l10n.errorTimeoutMessage;
      case NetworkErrorType.maintenance:
        return l10n.errorMaintenanceMessage;
      case NetworkErrorType.generic:
        return l10n.errorGenericMessage;
    }
  }

  Future<void> _handleRetry() async {
    if (widget.onRetry == null || _isRetrying) return;
    setState(() => _isRetrying = true);
    try {
      await widget.onRetry!();
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titleText = widget.title ?? _titleFor(l10n);
    final messageText = widget.message ?? _messageFor(l10n);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: widget.isCompact ? 20 : 36,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 3D Error / No-Internet Character Hero Illustration
            Container(
              constraints: BoxConstraints(
                maxHeight: widget.isCompact ? 170 : 250,
              ),
              child: Image.asset(
                'assets/images/network_error.webp',
                fit: BoxFit.contain,
              )
                  .animate()
                  .scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1, 1),
                  )
                  .fadeIn(duration: 300.ms),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              titleText,
              style: AppTypography.of(context).h2.copyWith(
                fontSize: widget.isCompact ? 18 : 22,
                color: AppColors.of(context).navy,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 300.ms)
                .slideY(begin: 0.15, end: 0),

            const SizedBox(height: 8),

            // Subtitle description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                messageText,
                style: AppTypography.of(context).body.copyWith(
                  fontSize: 14,
                  color: AppColors.of(context).bodyText,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            )
                .animate()
                .fadeIn(delay: 180.ms, duration: 300.ms)
                .slideY(begin: 0.15, end: 0),

            const SizedBox(height: 24),

            // Action Buttons
            if (widget.onRetry != null)
              SizedBox(
                width: widget.isCompact ? 160 : 200,
                child: PrimaryButton(
                  label: _isRetrying ? l10n.tryingAgainLabel : l10n.tryAgainLabel,
                  icon: _isRetrying ? null : AppIcons.arrow_clockwise,
                  onPressed: _isRetrying ? null : _handleRetry,
                ),
              )
                  .animate()
                  .fadeIn(delay: 240.ms, duration: 300.ms)
                  .slideY(begin: 0.2, end: 0),

            if (widget.onSecondaryAction != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: widget.isCompact ? 160 : 200,
                child: AppOutlineButton(
                  label: widget.secondaryActionLabel ?? l10n.goBackLabel,
                  onPressed: widget.onSecondaryAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full screen scaffold wrapper for Network Error state.
class NetworkErrorScreen extends StatelessWidget {
  final NetworkErrorType type;
  final String? title;
  final String? message;
  final Future<void> Function()? onRetry;
  final VoidCallback? onBack;

  const NetworkErrorScreen({
    super.key,
    this.type = NetworkErrorType.noInternet,
    this.title,
    this.message,
    this.onRetry,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: onBack != null
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(AppIcons.arrow_left, color: AppColors.of(context).navy),
                onPressed: onBack,
              ),
            )
          : null,
      body: SafeArea(
        child: NetworkErrorView(
          type: type,
          title: title,
          message: message,
          onRetry: onRetry,
          onSecondaryAction: onBack,
        ),
      ),
    );
  }
}
