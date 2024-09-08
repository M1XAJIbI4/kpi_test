// Flutter imports:
import 'package:flutter/material.dart';

class ScalingButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Widget? childDisabled;
  final double lowerBound;

  const ScalingButton({
    super.key,
    required this.onTap,
    required this.child,
    this.childDisabled,
    this.lowerBound = 0.8,
  });

  @override
  State<ScalingButton> createState() => _ScalingButtonState();
}

class _ScalingButtonState extends State<ScalingButton>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
    lowerBound: widget.lowerBound,
    upperBound: 1,
    duration: const Duration(milliseconds: 50),
    value: 1,
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _controller.value,
        child: child,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.onTap != null
            ? (details) => _controller.animateTo(
                  _controller.lowerBound,
                )
            : null,
        onTapUp: widget.onTap != null
            ? (details) {
                _controller.animateTo(
                  _controller.upperBound,
                );
                widget.onTap?.call();
              }
            : null,
        onTapCancel: () => _controller.animateTo(
          _controller.upperBound,
        ),
        child: widget.child,
      ),
    );
  }
}
