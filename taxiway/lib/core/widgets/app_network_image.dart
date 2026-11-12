import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A remote image that is cached on disk between launches, decoded at roughly
/// the size it is shown at (not its full download size), and replaced by
/// [fallback] while loading fails.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final Widget fallback;
  final BoxFit fit;
  final int decodeWidth;

  const AppNetworkImage({
    super.key,
    required this.url,
    required this.fallback,
    this.fit = BoxFit.contain,
    this.decodeWidth = 320,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: decodeWidth,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (context, _) => const SizedBox.shrink(),
      errorWidget: (context, _, _) => fallback,
    );
  }
}
