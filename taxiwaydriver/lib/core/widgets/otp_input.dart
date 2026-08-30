import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Professional, highly animated 6-digit OTP input widget for Driver App.
/// Features modern squircle roundness, dynamic outer glow stroke,
/// breathing cursor indicator, pop-scale bounce on entry, and spring shake on error.
class OtpInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final int length;

  const OtpInput({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 6,
  });

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> with TickerProviderStateMixin {
  late final List<TextEditingController> _controllers = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _nodes = List.generate(
    widget.length,
    (_) => FocusNode(),
  );
  late final List<int> _popTicks = List.filled(widget.length, 0);
  bool _hasError = false;

  late final AnimationController _shakeController = AnimationController(
    duration: const Duration(milliseconds: 480),
    vsync: this,
  );

  late final Animation<double> _shakeAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: -9.0).chain(CurveTween(curve: Curves.easeOutQuad)),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween(begin: -9.0, end: 9.0).chain(CurveTween(curve: Curves.easeInOutQuad)),
      weight: 2,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 9.0, end: -6.0).chain(CurveTween(curve: Curves.easeInOutQuad)),
      weight: 2,
    ),
    TweenSequenceItem(
      tween: Tween(begin: -6.0, end: 5.0).chain(CurveTween(curve: Curves.easeInOutQuad)),
      weight: 2,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 5.0, end: -2.0).chain(CurveTween(curve: Curves.easeInOutQuad)),
      weight: 1,
    ),
    TweenSequenceItem(
      tween: Tween(begin: -2.0, end: 0.0).chain(CurveTween(curve: Curves.easeInQuad)),
      weight: 1,
    ),
  ]).animate(_shakeController);

  // Smooth breathing animation for active empty cell indicator
  late final AnimationController _cursorController = AnimationController(
    duration: const Duration(milliseconds: 850),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.length; i++) {
      final index = i;
      _nodes[index].addListener(() => setState(() {}));
      _nodes[index].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _controllers[index].text.isEmpty &&
            index > 0) {
          _nodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
          _notify();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    _shakeController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  /// Shakes the boxes to signal a rejected code, flashes error stroke, then clears them.
  Future<void> shakeAndClear() async {
    setState(() => _hasError = true);
    await _shakeController.forward(from: 0);
    if (!mounted) return;
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _hasError = false);
    _nodes.first.requestFocus();
  }

  /// Fills the boxes from a full code, e.g. pasted or auto-read from an SMS/debug.
  void setCode(String code) {
    if (_hasError) setState(() => _hasError = false);
    _fillFrom(code);
  }

  /// Clears all input boxes and focuses on the first one.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _hasError = false);
    _notify();
    _nodes.first.requestFocus();
  }

  void _fillFrom(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    for (var i = 0; i < widget.length && i < digits.length; i++) {
      _controllers[i].text = digits[i];
      _popTicks[i]++;
    }
    final lastIndex = digits.length.clamp(0, widget.length) - 1;
    if (lastIndex >= 0 && lastIndex < widget.length - 1) {
      _nodes[lastIndex + 1].requestFocus();
    } else if (digits.length >= widget.length) {
      FocusScope.of(context).unfocus();
    }
    _notify();
  }

  void _onCellChanged(int index, String value) {
    if (_hasError) setState(() => _hasError = false);

    if (value.length > 1) {
      // Handle paste across cells
      _fillFrom(value);
      return;
    }

    if (value.isNotEmpty) {
      _popTicks[index]++;
      if (index < widget.length - 1) {
        _nodes[index + 1].requestFocus();
      } else {
        _nodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    _notify();
  }

  void _notify() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final gap = math.min(10.0, math.max(6.0, (totalWidth - (widget.length * 48)) / (widget.length - 1)));
          final boxWidth = math.min(52.0, (totalWidth - (gap * (widget.length - 1))) / widget.length);
          final boxHeight = math.max(58.0, boxWidth * 1.22);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (i) {
              final isFocused = _nodes[i].hasFocus;
              final hasValue = _controllers[i].text.isNotEmpty;

              Color borderColor;
              double borderWidth;
              Color backgroundColor;
              List<BoxShadow> boxShadows;
              double scale = 1.0;

              if (_hasError) {
                borderColor = AppColors.of(context).error;
                borderWidth = 2.2;
                backgroundColor = AppColors.of(context).errorBackground;
                boxShadows = [
                  BoxShadow(
                    color: AppColors.of(context).error.withValues(alpha: 0.28),
                    blurRadius: 10,
                    spreadRadius: 1.5,
                    offset: const Offset(0, 2),
                  ),
                ];
              } else if (isFocused) {
                borderColor = AppColors.of(context).primary;
                borderWidth = 2.2;
                backgroundColor = Colors.white;
                scale = 1.04;
                boxShadows = [
                  BoxShadow(
                    color: AppColors.of(context).primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1.5,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: AppColors.of(context).primary.withValues(alpha: 0.10),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ];
              } else if (hasValue) {
                borderColor = AppColors.of(context).navySecondary.withValues(alpha: 0.85);
                borderWidth = 1.8;
                backgroundColor = Colors.white;
                boxShadows = [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ];
              } else {
                borderColor = AppColors.of(context).border;
                borderWidth = 1.5;
                backgroundColor = const Color(0xFFF8FAFC);
                boxShadows = [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1.5),
                  ),
                ];
              }

              return TweenAnimationBuilder<double>(
                key: ValueKey('$i-${_popTicks[i]}'),
                tween: Tween(begin: hasValue ? 1.20 : 1.0, end: 1.0),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                builder: (context, popScale, child) {
                  return Transform.scale(
                    scale: popScale,
                    child: child,
                  );
                },
                child: AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _nodes[i].requestFocus(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      width: boxWidth,
                      height: boxHeight,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                        boxShadow: boxShadows,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Breathing active cursor indicator when focused and empty
                          if (isFocused && !hasValue && !_hasError)
                            AnimatedBuilder(
                              animation: _cursorController,
                              builder: (context, _) {
                                return Opacity(
                                  opacity: _cursorController.value,
                                  child: Container(
                                    width: 2.5,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.of(context).primary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              },
                            ),

                          TextField(
                            controller: _controllers[i],
                            focusNode: _nodes[i],
                            autofocus: i == 0,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            maxLength: i == 0 ? widget.length : 1,
                            showCursor: false,
                            style: AppTypography.of(context).h2.copyWith(
                              color: _hasError ? AppColors.of(context).error : AppColors.of(context).navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                            cursorColor: AppColors.of(context).primary,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (v) => _onCellChanged(i, v),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
