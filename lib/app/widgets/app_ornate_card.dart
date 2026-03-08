import 'package:flutter/material.dart';

enum AppOrnateCardAura { ember, tide, spark, noir, aurora, solar }

class AppOrnateCard extends StatelessWidget {
  const AppOrnateCard({
    super.key,
    required this.child,
    required this.accentColor,
    this.highlightColor,
    this.aura = AppOrnateCardAura.solar,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 24,
    this.gradient,
    this.overlay,
  });

  final Widget child;
  final Color accentColor;
  final Color? highlightColor;
  final AppOrnateCardAura aura;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Gradient? gradient;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight =
        highlightColor ?? Color.lerp(accentColor, Colors.white, 0.46)!;
    final resolvedGradient =
        gradient ??
        LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.98),
            Color.lerp(theme.colorScheme.surface, accentColor, 0.12)!,
            Color.lerp(theme.colorScheme.surface, highlight, 0.08)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Color.lerp(
            accentColor,
            highlight,
            0.35,
          )!.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: highlight.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(-8, -6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: resolvedGradient),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _OrnateAuraPainter(
                  accentColor: accentColor,
                  highlightColor: highlight,
                  aura: aura,
                ),
              ),
            ),
            Positioned(
              top: -42,
              right: -18,
              child: _GlowOrb(
                color: highlight.withValues(alpha: 0.26),
                size: 132,
              ),
            ),
            Positioned(
              left: -24,
              bottom: -44,
              child: _GlowOrb(
                color: accentColor.withValues(alpha: 0.2),
                size: 118,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.transparent,
                        accentColor.withValues(alpha: 0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0, 0.34, 1],
                    ),
                  ),
                ),
              ),
            ),
            if (overlay != null) Positioned.fill(child: overlay!),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: size * 0.36, spreadRadius: 8),
        ],
      ),
    );
  }
}

class _OrnateAuraPainter extends CustomPainter {
  const _OrnateAuraPainter({
    required this.accentColor,
    required this.highlightColor,
    required this.aura,
  });

  final Color accentColor;
  final Color highlightColor;
  final AppOrnateCardAura aura;

  @override
  void paint(Canvas canvas, Size size) {
    _paintSharedGlow(canvas, size);

    switch (aura) {
      case AppOrnateCardAura.ember:
        _paintEmberAura(canvas, size);
      case AppOrnateCardAura.tide:
        _paintTideAura(canvas, size);
      case AppOrnateCardAura.spark:
        _paintSparkAura(canvas, size);
      case AppOrnateCardAura.noir:
        _paintNoirAura(canvas, size);
      case AppOrnateCardAura.aurora:
        _paintAuroraAura(canvas, size);
      case AppOrnateCardAura.solar:
        _paintSolarAura(canvas, size);
    }

    _paintSparkles(canvas, size);
  }

  void _paintSharedGlow(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26);
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.22),
      size.shortestSide * 0.2,
      glowPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.84),
      size.shortestSide * 0.16,
      glowPaint..color = highlightColor.withValues(alpha: 0.08),
    );
  }

  void _paintEmberAura(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accentColor.withValues(alpha: 0.22);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = highlightColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
    final flame = Path()
      ..moveTo(size.width * 0.08, size.height * 0.92)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.62,
        size.width * 0.28,
        size.height * 0.88,
        size.width * 0.36,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.44,
        size.height * 0.28,
        size.width * 0.56,
        size.height * 0.68,
        size.width * 0.68,
        size.height * 0.34,
      )
      ..cubicTo(
        size.width * 0.78,
        size.height * 0.14,
        size.width * 0.88,
        size.height * 0.42,
        size.width * 0.94,
        size.height * 0.12,
      );
    canvas.drawPath(flame, glow);
    canvas.drawPath(flame, stroke);
  }

  void _paintTideAura(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = accentColor.withValues(alpha: 0.22);
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = highlightColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    for (var index = 0; index < 3; index += 1) {
      final baseline = size.height * (0.22 + index * 0.2);
      final path = Path()
        ..moveTo(-10, baseline)
        ..cubicTo(
          size.width * 0.18,
          baseline - 20,
          size.width * 0.32,
          baseline + 18,
          size.width * 0.52,
          baseline - 12,
        )
        ..cubicTo(
          size.width * 0.72,
          baseline - 40,
          size.width * 0.84,
          baseline + 10,
          size.width + 20,
          baseline - 18,
        );
      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, wavePaint);
    }
  }

  void _paintSparkAura(Canvas canvas, Size size) {
    final boltPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4
      ..color = accentColor.withValues(alpha: 0.26);
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..color = highlightColor.withValues(alpha: 0.09)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

    final bolt = Path()
      ..moveTo(size.width * 0.68, size.height * 0.08)
      ..lineTo(size.width * 0.56, size.height * 0.3)
      ..lineTo(size.width * 0.72, size.height * 0.34)
      ..lineTo(size.width * 0.48, size.height * 0.68)
      ..lineTo(size.width * 0.62, size.height * 0.66)
      ..lineTo(size.width * 0.4, size.height * 0.94);
    canvas.drawPath(bolt, glowPaint);
    canvas.drawPath(bolt, boltPaint);
  }

  void _paintNoirAura(Canvas canvas, Size size) {
    final mistPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = accentColor.withValues(alpha: 0.16);

    for (var index = 0; index < 4; index += 1) {
      final y = size.height * (0.18 + index * 0.18);
      final path = Path()
        ..moveTo(size.width * 0.06, y)
        ..cubicTo(
          size.width * 0.26,
          y - 12,
          size.width * 0.48,
          y + 12,
          size.width * 0.92,
          y - 6,
        );
      canvas.drawPath(path, mistPaint);
    }
  }

  void _paintAuroraAura(Canvas canvas, Size size) {
    final ribbonPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = accentColor.withValues(alpha: 0.22);
    final ribbonGlow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = highlightColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    final ribbon = Path()
      ..moveTo(size.width * 0.04, size.height * 0.66)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.4,
        size.width * 0.36,
        size.height * 0.82,
        size.width * 0.58,
        size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.26,
        size.width * 0.88,
        size.height * 0.62,
        size.width * 0.96,
        size.height * 0.36,
      );
    canvas.drawPath(ribbon, ribbonGlow);
    canvas.drawPath(ribbon, ribbonPaint);
  }

  void _paintSolarAura(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = accentColor.withValues(alpha: 0.2);
    final center = Offset(size.width * 0.78, size.height * 0.22);
    canvas.drawCircle(center, size.shortestSide * 0.11, ringPaint);
    canvas.drawCircle(
      center,
      size.shortestSide * 0.17,
      ringPaint..color = highlightColor.withValues(alpha: 0.14),
    );

    final rayPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = accentColor.withValues(alpha: 0.18);
    for (var index = 0; index < 5; index += 1) {
      final startX = size.width * (0.16 + index * 0.12);
      canvas.drawLine(
        Offset(startX, size.height * 0.86),
        Offset(startX + 20, size.height * 0.68),
        rayPaint,
      );
    }
  }

  void _paintSparkles(Canvas canvas, Size size) {
    final points = <Offset>[
      Offset(size.width * 0.16, size.height * 0.16),
      Offset(size.width * 0.84, size.height * 0.54),
      Offset(size.width * 0.62, size.height * 0.84),
    ];
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = highlightColor.withValues(alpha: 0.32);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.22);

    for (final point in points) {
      canvas.drawCircle(point, 1.8, fillPaint);
      canvas.drawLine(
        Offset(point.dx, point.dy - 8),
        Offset(point.dx, point.dy + 8),
        strokePaint,
      );
      canvas.drawLine(
        Offset(point.dx - 8, point.dy),
        Offset(point.dx + 8, point.dy),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrnateAuraPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.aura != aura;
  }
}
