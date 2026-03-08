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
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.scaffoldBackgroundColor,
            scheme.primary.withValues(alpha: 0.08),
            scheme.tertiary.withValues(alpha: 0.06),
          ],
          begin: const Alignment(-0.9, -1),
          end: const Alignment(0.9, 1),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _BackdropPainter(
                  primaryColor: scheme.primary.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.24 : 0.16,
                  ),
                  secondaryColor: scheme.tertiary.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.14 : 0.1,
                  ),
                  primaryAlignment: primaryAlignment,
                  secondaryAlignment: secondaryAlignment,
                  confettiColor: scheme.secondary.withValues(
                    alpha: theme.brightness == Brightness.dark ? 0.22 : 0.18,
                  ),
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
    required this.confettiColor,
    required this.showGrid,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Alignment primaryAlignment;
  final Alignment secondaryAlignment;
  final Color confettiColor;
  final bool showGrid;

  @override
  void paint(Canvas canvas, Size size) {
    final primaryCenter = primaryAlignment.alongSize(size);
    final secondaryCenter = secondaryAlignment.alongSize(size);

    canvas.drawCircle(
      primaryCenter,
      size.shortestSide * 0.44,
      Paint()..color = primaryColor,
    );
    canvas.drawCircle(
      secondaryCenter,
      size.shortestSide * 0.34,
      Paint()..color = secondaryColor,
    );

    final wavePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final wavePath = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.12,
        size.width * 0.46,
        size.height * 0.24,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.38,
        size.width,
        size.height * 0.28,
      );
    canvas.drawPath(wavePath, wavePaint);

    final wavePaintSecondary = Paint()
      ..color = secondaryColor.withValues(alpha: 0.32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final wavePathSecondary = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.66,
        size.width * 0.52,
        size.height * 0.82,
      )
      ..quadraticBezierTo(
        size.width * 0.74,
        size.height * 0.94,
        size.width,
        size.height * 0.84,
      );
    canvas.drawPath(wavePathSecondary, wavePaintSecondary);

    if (!showGrid) {
      return;
    }

    final confettiPaint = Paint()..color = confettiColor;
    const density = 18;
    for (int i = 0; i < density; i++) {
      final x = size.width * (((i * 37) % 100) / 100);
      final y = size.height * (((i * 53 + 17) % 100) / 100);
      final w = size.width * 0.012;
      final h = size.height * 0.0045;
      final rect = Rect.fromCenter(center: Offset(x, y), width: w, height: h);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(h / 2));
      canvas.drawRRect(
        rrect,
        confettiPaint..color = confettiColor.withValues(alpha: 0.45),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.confettiColor != confettiColor ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.primaryAlignment != primaryAlignment ||
        oldDelegate.secondaryAlignment != secondaryAlignment;
  }
}
