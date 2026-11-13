import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

const _lightFilter = ColorFilter.matrix(<double>[
  0.5, 0.45, 0.05, 0, 6,
  0.14, 0.81, 0.05, 0, 6,
  0.14, 0.43, 0.43, 0, 6,
  0, 0, 0, 1, 0,
]);

const _darkFilter = ColorFilter.matrix(<double>[
  -0.62, -0.58, -0.06, 0, 255,
  -0.18, -0.98, -0.06, 0, 255,
  -0.18, -0.54, -0.54, 0, 255,
  0, 0, 0, 1, 0,
]);

class OsmTileLayer extends StatelessWidget {
  const OsmTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.taxiway.user.arknox',
      maxNativeZoom: 19,
      tileBuilder: (context, tileWidget, tile) => ColorFiltered(
        colorFilter: dark ? _darkFilter : _lightFilter,
        child: tileWidget,
      ),
    );
  }
}

class OsmAttribution extends StatelessWidget {
  const OsmAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '© OpenStreetMap contributors',
          style: TextStyle(fontSize: 10, color: Color(0xFF3A3B40)),
        ),
      ),
    );
  }
}
