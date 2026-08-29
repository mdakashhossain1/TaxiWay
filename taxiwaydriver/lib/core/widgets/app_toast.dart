import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum ToastType { success, info, warning, error, phone }

/// Modern, animated floating toast notification system for Taxiway.
class AppToast {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(milliseconds: 2800),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) => _AnimatedToastWidget(
        message: message,
        title: title,
        type: type,
        duration: duration,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void success(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.success);
  }

  static void error(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.error);
  }

  static void info(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.info);
  }

  static void call(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.phone);
  }
}

class _AnimatedToastWidget extends StatefulWidget {
  final String message;
  final String? title;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _AnimatedToastWidget({
    required this.message,
    this.title,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_AnimatedToastWidget> createState() => _AnimatedToastWidgetState();
}

class _AnimatedToastWidgetState extends State<_AnimatedToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _bgBorderColor {
    switch (widget.type) {
      case ToastType.success:
        return const Color(0xFF22C55E);
      case ToastType.error:
        return const Color(0xFFEF4444);
      case ToastType.warning:
        return const Color(0xFFF59E0B);
      case ToastType.phone:
        return const Color(0xFF2563EB);
      case ToastType.info:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case ToastType.success:
        return BootstrapIcons.check_circle_fill;
      case ToastType.error:
        return BootstrapIcons.exclamation_triangle_fill;
      case ToastType.warning:
        return BootstrapIcons.exclamation_circle_fill;
      case ToastType.phone:
        return BootstrapIcons.telephone_fill;
      case ToastType.info:
        return BootstrapIcons.info_circle_fill;
    }
  }

  Color get _iconColor {
    switch (widget.type) {
      case ToastType.success:
        return const Color(0xFF16A34A);
      case ToastType.error:
        return const Color(0xFFDC2626);
      case ToastType.warning:
        return const Color(0xFFD97706);
      case ToastType.phone:
        return const Color(0xFF2563EB);
      case ToastType.info:
        return AppColors.primary;
    }
  }

  Color get _iconBgColor {
    switch (widget.type) {
      case ToastType.success:
        return const Color(0xFFDCFCE7);
      case ToastType.error:
        return const Color(0xFFFEE2E2);
      case ToastType.warning:
        return const Color(0xFFFEF3C7);
      case ToastType.phone:
        return const Color(0xFFDBEAFE);
      case ToastType.info:
        return AppColors.primaryBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: child,
                ),
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              _controller.reverse().then((_) => widget.onDismiss());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: _bgBorderColor.withValues(alpha: 0.4), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(_icon, color: _iconColor, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null) ...[
                          Text(
                            widget.title!,
                            style: AppTypography.label.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          widget.message,
                          style: AppTypography.body.copyWith(
                            color: const Color(0xFFF1F5F9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
