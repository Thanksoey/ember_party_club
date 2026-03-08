import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 26,
    this.strokeWidth = 2.6,
  });

  final double size;
  final double strokeWidth;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ArcLoaderPainter(
              value: _controller.value,
              color: scheme.primary,
              sparkColor: scheme.secondary,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _ArcLoaderPainter extends CustomPainter {
  const _ArcLoaderPainter({
    required this.value,
    required this.color,
    required this.sparkColor,
    required this.strokeWidth,
  });

  final double value;
  final Color color;
  final Color sparkColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = color.withValues(alpha: 0.22);
    canvas.drawCircle(center, radius, trackPaint);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = color;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final start = -math.pi / 2 + value * 2 * math.pi;
    final sweep = math.pi * (0.52 + 0.28 * math.sin(value * 2 * math.pi));
    canvas.drawArc(rect, start, sweep, false, paint);

    final sparkPaint = Paint()..color = sparkColor.withValues(alpha: 0.94);
    final sparkRadius = size.shortestSide * 0.065;
    for (int i = 0; i < 3; i++) {
      final phase = value * 2 * math.pi + i * (math.pi * 2 / 3);
      final orbit = radius * 0.84;
      final dx = center.dx + math.cos(phase) * orbit;
      final dy = center.dy + math.sin(phase) * orbit;
      canvas.drawCircle(Offset(dx, dy), sparkRadius, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArcLoaderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.sparkColor != sparkColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
