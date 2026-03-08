import 'package:flutter/material.dart';

class AppFadeInUp extends StatelessWidget {
  const AppFadeInUp({
    super.key,
    required this.child,
    this.order = 0,
    this.distance = 12,
  });

  final Widget child;
  final int order;
  final double distance;

  @override
  Widget build(BuildContext context) {
    final delay = (order * 40).clamp(0, 260);
    final durationMs = 260 + delay;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: durationMs),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * distance),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}
