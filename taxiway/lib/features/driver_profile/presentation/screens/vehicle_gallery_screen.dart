import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/vehicle.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/vehicle_media_placeholder.dart';

class VehicleGalleryScreen extends ConsumerWidget {
  const VehicleGalleryScreen({super.key});

  void _openViewer(BuildContext context, VehicleMedia media) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: media.category == VehicleMediaCategory.interior ? 4 / 3 : 16 / 9,
              child: VehicleMediaTile(media: media, radius: BorderRadius.circular(16)),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(BootstrapIcons.x_lg, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(currentVehicleProvider);
    final photos = vehicle.media.where((m) => m.type == VehicleMediaType.photo).toList();
    final videos = vehicle.media.where((m) => m.type == VehicleMediaType.video).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('Vehicle Gallery'),
          bottom: TabBar(
            labelColor: AppColors.of(context).primary,
            unselectedLabelColor: AppColors.of(context).mutedText,
            indicatorColor: AppColors.of(context).primary,
            tabs: const [Tab(text: 'Photos'), Tab(text: 'Videos')],
          ),
        ),
        body: TabBarView(
          children: [
            _MediaGrid(media: photos, onTap: (m) => _openViewer(context, m)),
            videos.isEmpty
                ? Center(child: Text('No videos yet.', style: AppTypography.of(context).body))
                : _MediaGrid(media: videos, onTap: (m) => _openViewer(context, m)),
          ],
        ),
      ),
    );
  }
}

class _MediaGrid extends StatelessWidget {
  final List<VehicleMedia> media;
  final ValueChanged<VehicleMedia> onTap;
  const _MediaGrid({required this.media, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: media.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, i) => VehicleMediaTile(media: media[i], onTap: () => onTap(media[i]))
          .animate()
          .fadeIn(delay: (40 * i).ms, duration: 260.ms)
          .scale(delay: (40 * i).ms, duration: 260.ms, begin: const Offset(0.92, 0.92), end: const Offset(1, 1)),
    );
  }
}
