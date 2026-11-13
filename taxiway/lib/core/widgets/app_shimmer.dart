import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// Shimmer wrapper. Wrap only the pieces that stand in for content, never the
/// card or screen background behind them: the shimmer paints every opaque
/// pixel of its child, so a white card inside it becomes one grey block.
/// [onSurface] uses a slightly darker tone for pieces sitting on a grey card.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final bool onSurface;

  const AppShimmer({super.key, required this.child, this.onSurface = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = AppColors.of(context);
    final Color base;
    final Color highlight;
    if (isDark) {
      base = onSurface ? colors.borderStrong : colors.surface;
      highlight = onSurface ? colors.mutedText.withValues(alpha: 0.5) : colors.border;
    } else {
      base = onSurface ? const Color(0xFFE3E3E6) : const Color(0xFFEDEDEF);
      highlight = onSurface ? const Color(0xFFF1F1F3) : const Color(0xFFF8F8F9);
    }

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// A rectangular skeleton box with rounded corners.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A circular skeleton placeholder (for avatars, icons, buttons).
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({super.key, required this.size, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    );
  }
}

/// A skeleton text line with rounded pill ends.
class ShimmerLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerLine({super.key, this.width, this.height = 12, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

/// Stands in for one line of text set in [style]. It occupies exactly the
/// line box the real text will, so the loaded content never shifts the layout.
class ShimmerText extends StatelessWidget {
  final TextStyle style;
  final double? width;
  final Alignment alignment;

  const ShimmerText({super.key, required this.style, this.width, this.alignment = Alignment.centerLeft});

  @override
  Widget build(BuildContext context) {
    final fontSize = style.fontSize ?? 14;
    final lineHeight = (style.height ?? 1.2) * fontSize;

    return SizedBox(
      height: lineHeight,
      width: width,
      child: Align(
        alignment: alignment,
        child: ShimmerLine(width: width, height: fontSize * 0.72),
      ),
    );
  }
}

/// Generic page skeleton with header, summary card, and list items.
class GeneralPageShimmer extends StatelessWidget {
  const GeneralPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerLine(width: 160, height: 22),
            SizedBox(height: 8),
            ShimmerLine(width: 240, height: 13),
            SizedBox(height: 24),
            ShimmerBox(width: double.infinity, height: 110, borderRadius: 14),
            SizedBox(height: 20),
            ShimmerLine(width: 120, height: 16),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 64, borderRadius: 10),
            SizedBox(height: 10),
            ShimmerBox(width: double.infinity, height: 64, borderRadius: 10),
            SizedBox(height: 10),
            ShimmerBox(width: double.infinity, height: 64, borderRadius: 10),
          ],
        ),
      ),
    );
  }
}

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  static const _rows = [(false, 0.55), (true, 0.4), (false, 0.7), (true, 0.5), (false, 0.45)];

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          for (final (mine, factor) in _rows)
            Align(
              alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: factor,
                child: const ShimmerBox(height: 44, borderRadius: 16, margin: EdgeInsets.symmetric(vertical: 6)),
              ),
            ),
        ],
      ),
    );
  }
}
