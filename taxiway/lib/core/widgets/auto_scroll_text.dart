import 'package:flutter/material.dart';

/// One-line text that shows in full. When the text is wider than the space it
/// has, it pauses, scrolls to the end, pauses and scrolls back, repeating, so
/// a long place name can be read instead of being cut off with "...".
class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pause;
  final double pixelsPerSecond;

  const AutoScrollText(
    this.text, {
    super.key,
    this.style,
    this.pause = const Duration(milliseconds: 1400),
    this.pixelsPerSecond = 38,
  });

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  final ScrollController _controller = ScrollController();
  bool _looping = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AutoScrollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && _controller.hasClients) {
      _controller.jumpTo(0);
    }
  }

  Future<void> _loop() async {
    if (_looping) return;
    _looping = true;
    while (!_disposed) {
      await Future<void>.delayed(widget.pause);
      if (_disposed || !_controller.hasClients) break;
      final extent = _controller.position.maxScrollExtent;
      if (extent <= 0) break;
      final forward = Duration(milliseconds: (extent / widget.pixelsPerSecond * 1000).round());
      await _controller.animateTo(extent, duration: forward, curve: Curves.linear);
      if (_disposed || !_controller.hasClients) break;
      await Future<void>.delayed(widget.pause);
      if (_disposed || !_controller.hasClients) break;
      await _controller.animateTo(0, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    }
    _looping = false;
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        final overflows = painter.width > constraints.maxWidth + 0.5;

        if (!overflows || reduceMotion) {
          return Text(widget.text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_disposed) _loop();
        });

        return SizedBox(
          height: painter.height,
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.black, Colors.black, Colors.transparent],
              stops: [0, 0.9, 1],
            ).createShader(bounds),
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(widget.text, style: style, maxLines: 1, softWrap: false),
            ),
          ),
        );
      },
    );
  }
}
