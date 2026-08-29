import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  String get _defaultTitle {
    switch (widget.type) {
      case NetworkErrorType.noInternet:
        return 'No Internet Connection';
      case NetworkErrorType.serverError:
        return 'Server Unavailable';
      case NetworkErrorType.timeout:
        return 'Connection Timed Out';
      case NetworkErrorType.maintenance:
        return 'Under Scheduled Maintenance';
      case NetworkErrorType.generic:
        return 'Something Went Wrong';
    }
  }

  String get _defaultMessage {
    switch (widget.type) {
      case NetworkErrorType.noInternet:
        return 'Please check your Wi-Fi or mobile data connection and try again.';
      case NetworkErrorType.serverError:
        return 'Our servers are experiencing heavy traffic or temporary downtime. We are working on it.';
      case NetworkErrorType.timeout:
        return 'The request took too long to complete. Please check your signal strength.';
      case NetworkErrorType.maintenance:
        return 'Taxiway is undergoing regular maintenance to serve you better. Back shortly!';
      case NetworkErrorType.generic:
        return 'An unexpected issue occurred while fetching data. Tap below to retry.';
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
    final titleText = widget.title ?? _defaultTitle;
    final messageText = widget.message ?? _defaultMessage;

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
                'assets/images/network_error.png',
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
              style: AppTypography.h2.copyWith(
                fontSize: widget.isCompact ? 18 : 22,
                color: AppColors.navy,
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
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: AppColors.bodyText,
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
                  label: _isRetrying ? 'Connecting...' : 'Try Again',
                  icon: _isRetrying ? null : BootstrapIcons.arrow_clockwise,
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
                  label: widget.secondaryActionLabel ?? 'Go Back',
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
                icon: const Icon(BootstrapIcons.arrow_left, color: AppColors.navy),
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
