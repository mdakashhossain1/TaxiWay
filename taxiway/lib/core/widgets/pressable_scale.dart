import 'package:flutter/material.dart';

/// Scales its child down while a finger is on it, the instant physical
/// feedback that makes taps feel acknowledged before the action even runs.
/// Listens to raw pointer events so it never competes with the child's own
/// tap handling.
class PressableScale extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double pressedScale;

  const PressableScale({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressedScale = 0.97,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value && mounted) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && _pressed && !MediaQuery.disableAnimationsOf(context);

    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: active ? widget.pressedScale : 1,
        duration: Duration(milliseconds: active ? 90 : 160),
        curve: active ? Curves.easeOut : Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
