import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The Taxiway Pin Logo: A vibrant orange map-pin containing a white car icon.
class TaxiwayPinLogo extends StatelessWidget {
  final double size;
  const TaxiwayPinLogo({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.18,
      child: CustomPaint(
        painter: _PinPainter(color: AppColors.of(context).primary),
        child: Padding(
          padding: EdgeInsets.only(bottom: size * 0.18),
          child: Center(
            child: Icon(
              BootstrapIcons.car_front_fill,
              color: Colors.white,
              size: size * 0.44,
            ),
          ),
        ),
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  final Color color;
  const _PinPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final w = size.width;
    final h = size.height;
    final r = w / 2;

    final path = Path()
      ..moveTo(r, h)
      ..cubicTo(w * 0.15, h * 0.65, 0, r + 4, 0, r)
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true)
      ..cubicTo(w, r + 4, w * 0.85, h * 0.65, r, h)
      ..close();

    // Draw soft shadow
    canvas.save();
    canvas.translate(0, 3);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hero illustration for Screen 02: Smartphone with orange 3-dots chat bubble,
/// botanical leaves, and subtle city building backdrop.
class PhoneAuthHeroIllustration extends StatelessWidget {
  final double size;
  const PhoneAuthHeroIllustration({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.3,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background City Skyline Silhouette
          Positioned(
            bottom: size * 0.1,
            child: SizedBox(
              width: size * 1.25,
              height: size * 0.6,
              child: CustomPaint(
                painter: _CityBackdropPainter(),
              ),
            ),
          ),

          // Botanical Leaf Accents
          Positioned(
            bottom: size * 0.08,
            left: size * 0.22,
            child: _DecorativeLeaves(angle: -0.35, color: const Color(0xFFEA580C)),
          ),
          Positioned(
            bottom: size * 0.08,
            right: size * 0.22,
            child: _DecorativeLeaves(angle: 0.35, color: const Color(0xFFEA580C)),
          ),

          // Smartphone Vector Frame
          Container(
            width: size * 0.46,
            height: size * 0.82,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E293B), width: 2.4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Speaker Notch
                Positioned(
                  top: 7,
                  child: Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Orange Chat Bubble with 3 dots
                Positioned(
                  top: size * 0.18,
                  right: -size * 0.12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.of(context).primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) => Container(
                        margin: EdgeInsets.only(right: i == 2 ? 0 : 3.5),
                        width: 4.5,
                        height: 4.5,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeLeaves extends StatelessWidget {
  final double angle;
  final Color color;
  const _DecorativeLeaves({required this.angle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(BootstrapIcons.flower1, size: 14, color: color.withValues(alpha: 0.8)),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}

class _CityBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Left building group
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.08, h * 0.35, w * 0.16, h * 0.65), const Radius.circular(4)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.22, h * 0.15, w * 0.15, h * 0.85), const Radius.circular(4)), paint);

    // Right building group
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.64, h * 0.2, w * 0.14, h * 0.8), const Radius.circular(4)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.76, h * 0.4, w * 0.16, h * 0.6), const Radius.circular(4)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Hero illustration for Screen 03: Shield with padlock, green checkmark badge,
/// and sparkle star accents.
class OtpHeroIllustration extends StatelessWidget {
  final double size;
  const OtpHeroIllustration({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.2,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkle Stars
          Positioned(
            top: size * 0.14,
            left: size * 0.12,
            child: Icon(BootstrapIcons.stars, size: 14, color: const Color(0xFFF97316).withValues(alpha: 0.45)),
          ),
          Positioned(
            top: size * 0.12,
            right: size * 0.18,
            child: Icon(BootstrapIcons.stars, size: 12, color: const Color(0xFFF97316).withValues(alpha: 0.4)),
          ),
          Positioned(
            bottom: size * 0.22,
            right: size * 0.1,
            child: Icon(BootstrapIcons.stars, size: 16, color: const Color(0xFFF97316).withValues(alpha: 0.5)),
          ),

          // Shield Body
          CustomPaint(
            size: Size(size * 0.62, size * 0.76),
            painter: _ShieldPainter(),
            child: SizedBox(
              width: size * 0.62,
              height: size * 0.76,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: size * 0.06),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.of(context).primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      BootstrapIcons.lock_fill,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Green Verified Checkmark Badge on Bottom Right of Shield
          Positioned(
            bottom: size * 0.16,
            right: size * 0.26,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.of(context).success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  BootstrapIcons.check_lg,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w / 2, 0)
      ..cubicTo(w * 0.9, 0, w, h * 0.25, w, h * 0.45)
      ..cubicTo(w, h * 0.75, w / 2, h, w / 2, h)
      ..cubicTo(w / 2, h, 0, h * 0.75, 0, h * 0.45)
      ..cubicTo(0, h * 0.25, w * 0.1, 0, w / 2, 0)
      ..close();

    // Shield background fill
    final bgPaint = Paint()
      ..color = const Color(0xFFFFF7ED)
      ..style = PaintingStyle.fill;

    // Shield outline border
    final borderPaint = Paint()
      ..color = const Color(0xFFFFEDD5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
