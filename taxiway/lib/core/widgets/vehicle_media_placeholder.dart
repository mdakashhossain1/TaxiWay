import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Stylized placeholder tile standing in for a real vehicle photo/video —
/// no external image assets are bundled. Category determines the icon and
/// a muted gradient so the gallery still reads as organized/photographic.
class VehicleMediaTile extends StatelessWidget {
  final VehicleMedia media;
  final VoidCallback? onTap;
  final BorderRadius radius;

  const VehicleMediaTile({
    super.key,
    required this.media,
    this.onTap,
    this.radius = const BorderRadius.all(Radius.circular(AppRadius.medium)),
  });

  IconData get _icon {
    switch (media.category) {
      case VehicleMediaCategory.exterior:
        return BootstrapIcons.car_front_fill;
      case VehicleMediaCategory.interior:
        return BootstrapIcons.person_fill;
      case VehicleMediaCategory.dashboard:
        return BootstrapIcons.speedometer2;
      case VehicleMediaCategory.boot:
        return BootstrapIcons.bag_fill;
    }
  }

  List<Color> get _gradient {
    switch (media.category) {
      case VehicleMediaCategory.exterior:
        return const [Color(0xFFE2E8F0), Color(0xFFCBD5E1)];
      case VehicleMediaCategory.interior:
        return const [Color(0xFFFFEDD5), Color(0xFFFED7AA)];
      case VehicleMediaCategory.dashboard:
        return const [Color(0xFFDBEAFE), Color(0xFFBFDBFE)];
      case VehicleMediaCategory.boot:
        return const [Color(0xFFDCFCE7), Color(0xFFBBF7D0)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: _gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Stack(
            children: [
              Center(child: Icon(_icon, size: 34, color: AppColors.of(context).navy.withValues(alpha: 0.55))),
              if (media.type == VehicleMediaType.video)
                const Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(BootstrapIcons.play_circle_fill, color: Colors.white, size: 22),
                ),
              Positioned(
                left: 8,
                bottom: 8,
                right: 8,
                child: Text(
                  media.type == VehicleMediaType.video && media.videoDuration != null
                      ? '${media.label}  ${media.videoDuration!.inSeconds ~/ 60}:${(media.videoDuration!.inSeconds % 60).toString().padLeft(2, '0')}'
                      : media.label,
                  style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).navy, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
