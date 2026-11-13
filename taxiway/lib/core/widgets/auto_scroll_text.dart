import 'package:flutter/material.dart';

/// One-line text that is always readable in full. When it is wider than the
/// space it has, it holds for a moment and then scrolls continuously to the
/// left as a marquee: a second copy follows the first, so the text wraps
/// around seamlessly and loops without ever bouncing back.
class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pause;
  final double pixelsPerSecond;
  final double gap;

  const AutoScrollText(
    this.text, {
    super.key,
    this.style,
    this.pause = const Duration(milliseconds: 1200),
    this.pixelsPerSecond = 42,
    this.gap = 36,
  });

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  bool _running = false;
  bool _disposed = false;
  double _cycle = 0;

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AutoScrollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _controller.value = 0;
  }

  Future<void> _run(double cycleWidth) async {
    if (_running && cycleWidth == _cycle) return;
    _cycle = cycleWidth;
    if (_running) return;
    _running = true;
    while (!_disposed && _cycle > 0) {
      _controller.value = 0;
      await Future<void>.delayed(widget.pause);
      if (_disposed) break;
      final duration = Duration(milliseconds: (_cycle / widget.pixelsPerSecond * 1000).round());
      await _controller.animateTo(1, duration: duration, curve: Curves.linear);
    }
    _running = false;
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
        final textWidth = painter.width;
        final overflows = textWidth > constraints.maxWidth + 0.5;

        if (!overflows || reduceMotion) {
          return Text(widget.text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
        }

        final cycleWidth = textWidth + widget.gap;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_disposed) _run(cycleWidth);
        });

        return SizedBox(
          height: painter.height,
          width: constraints.maxWidth,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scrolled = _controller.value > 0;
              return ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    scrolled ? Colors.transparent : Colors.black,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: const [0, 0.07, 0.92, 1],
                ).createShader(bounds),
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: 0,
                    maxWidth: double.infinity,
                    child: Transform.translate(offset: Offset(-_controller.value * cycleWidth, 0), child: child),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.text, style: style, maxLines: 1, softWrap: false),
                SizedBox(width: widget.gap),
                Text(widget.text, style: style, maxLines: 1, softWrap: false),
              ],
            ),
          ),
        );
      },
    );
  }
}
