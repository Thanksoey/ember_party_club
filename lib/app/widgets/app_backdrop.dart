import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({
    super.key,
    required this.child,
    this.primaryAlignment = const Alignment(-0.8, -0.9),
    this.secondaryAlignment = const Alignment(0.9, 0.8),
    this.showGrid = true,
  });

  final Widget child;
  final Alignment primaryAlignment;
  final Alignment secondaryAlignment;
  final bool showGrid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.scaffoldBackgroundColor,
            theme.colorScheme.primary.withValues(alpha: 0.05),
            theme.colorScheme.tertiary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _BackdropPainter(
                  primaryColor: theme.colorScheme.secondary.withValues(alpha: 0.18),
                  secondaryColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  primaryAlignment: primaryAlignment,
                  secondaryAlignment: secondaryAlignment,
                  gridColor: theme.colorScheme.outline.withValues(alpha: 0.18),
                  showGrid: showGrid,
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.primaryAlignment,
    required this.secondaryAlignment,
    required this.gridColor,
    required this.showGrid,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Alignment primaryAlignment;
  final Alignment secondaryAlignment;
  final Color gridColor;
  final bool showGrid;

  @override
  void paint(Canvas canvas, Size size) {
    final primaryCenter = primaryAlignment.alongSize(size);
    final secondaryCenter = secondaryAlignment.alongSize(size);

    canvas.drawCircle(primaryCenter, size.shortestSide * 0.44, Paint()..color = primaryColor);
    canvas.drawCircle(secondaryCenter, size.shortestSide * 0.34, Paint()..color = secondaryColor);

    if (!showGrid) {
      return;
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const spacing = 32.0;
    for (double dx = 0; dx < size.width; dx += spacing) {
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
    }
    for (double dy = 0; dy < size.height; dy += spacing) {
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.primaryAlignment != primaryAlignment ||
        oldDelegate.secondaryAlignment != secondaryAlignment;
  }
}
