import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingStars({super.key, required this.rating, this.size = 16, this.color = const Color(0xFFF59E0B)});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          half ? BootstrapIcons.star_half : (filled ? BootstrapIcons.star_fill : BootstrapIcons.star),
          size: size,
          color: filled || half ? color : AppColors.borderStrong,
        );
      }),
    );
  }
}

/// Large interactive star selector for the rating screen.
class InteractiveRatingStars extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const InteractiveRatingStars({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        final selected = starValue <= value;
        return IconButton(
          onPressed: () => onChanged(starValue),
          icon: AnimatedScale(
            scale: selected ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: Icon(
              selected ? BootstrapIcons.star_fill : BootstrapIcons.star,
              size: 40,
              color: selected ? const Color(0xFFF59E0B) : AppColors.borderStrong,
            ),
          ),
        )
            .animate()
            .fadeIn(delay: (60 * i).ms, duration: 300.ms)
            .scale(delay: (60 * i).ms, duration: 300.ms, curve: Curves.easeOutBack, begin: const Offset(0.4, 0.4), end: const Offset(1, 1));
      }),
    );
  }
}
