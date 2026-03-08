import 'dart:math' as math;

import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72, this.showWordmark = false});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        gradient: const LinearGradient(
          colors: [Color(0xFFB54922), Color(0xFFD99B46), Color(0xFF23110D)],
          stops: [0.0, 0.48, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFECD8C6).withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const CustomPaint(
        painter: _BrandPainter(
          gold: Color(0xFFF0C56A),
          goldBright: Color(0xFFFFE0A5),
          copper: Color(0xFF3A1C14),
          mint: Color(0xFF62D6C4),
          ivory: Color(0xFFF7EFE2),
        ),
      ),
    );

    if (!showWordmark) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '余烬派对社',
              style: theme.textTheme.titleLarge?.copyWith(
                letterSpacing: 0.3,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'EMBER PARTY CLUB',
              style: theme.textTheme.bodySmall?.copyWith(
                letterSpacing: 1.9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrandPainter extends CustomPainter {
  const _BrandPainter({
    required this.gold,
    required this.goldBright,
    required this.copper,
    required this.mint,
    required this.ivory,
  });

  final Color gold;
  final Color goldBright;
  final Color copper;
  final Color mint;
  final Color ivory;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final medallionRadius = radius * 0.6;
    final medallionRect = Rect.fromCircle(
      center: center,
      radius: medallionRadius,
    );
    final outerRingRect = Rect.fromCircle(
      center: center,
      radius: radius * 0.72,
    );
    final linkRect = Rect.fromCircle(center: center, radius: radius * 0.625);

    canvas.drawCircle(
      center,
      medallionRadius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.16, -0.22),
          colors: [
            const Color(0xFF4C2217),
            copper.withValues(alpha: 0.96),
            const Color(0xFF180B08),
          ],
          stops: const [0.0, 0.58, 1.0],
        ).createShader(medallionRect),
    );

    canvas.drawCircle(
      center,
      medallionRadius * 1.01,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.014
        ..color = Colors.black.withValues(alpha: 0.22),
    );

    canvas.drawCircle(
      center,
      medallionRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.018
        ..color = goldBright.withValues(alpha: 0.24),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: medallionRadius * 0.92),
      math.pi * 0.98,
      math.pi * 0.82,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.014
        ..color = Colors.black.withValues(alpha: 0.16),
    );

    canvas.drawCircle(
      center,
      radius * 0.72,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.032
        ..shader = SweepGradient(
          colors: [
            gold.withValues(alpha: 0.76),
            goldBright.withValues(alpha: 0.9),
            goldBright,
            gold.withValues(alpha: 0.82),
            gold.withValues(alpha: 0.76),
          ],
          stops: const [0.0, 0.18, 0.52, 0.84, 1.0],
        ).createShader(outerRingRect),
    );

    canvas.drawCircle(
      center,
      radius * 0.739,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.01
        ..color = goldBright.withValues(alpha: 0.36),
    );

    canvas.drawCircle(
      center,
      radius * 0.675,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.01
        ..color = goldBright.withValues(alpha: 0.34),
    );

    canvas.drawArc(
      linkRect,
      -2.5,
      1.16,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.022
        ..strokeCap = StrokeCap.butt
        ..shader = LinearGradient(
          colors: [
            mint.withValues(alpha: 0.18),
            mint.withValues(alpha: 0.5),
            mint.withValues(alpha: 0.18),
          ],
        ).createShader(linkRect),
    );
    canvas.drawArc(
      linkRect,
      0.18,
      1.16,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.022
        ..strokeCap = StrokeCap.butt
        ..shader = LinearGradient(
          colors: [
            mint.withValues(alpha: 0.18),
            mint.withValues(alpha: 0.46),
            mint.withValues(alpha: 0.18),
          ],
        ).createShader(linkRect),
    );

    final crownPath = Path()
      ..moveTo(center.dx, size.height * 0.18)
      ..lineTo(size.width * 0.535, size.height * 0.27)
      ..lineTo(size.width * 0.59, size.height * 0.27)
      ..lineTo(size.width * 0.545, size.height * 0.325)
      ..lineTo(center.dx, size.height * 0.295)
      ..lineTo(size.width * 0.455, size.height * 0.325)
      ..lineTo(size.width * 0.41, size.height * 0.27)
      ..lineTo(size.width * 0.465, size.height * 0.27)
      ..close();
    final crownBounds = crownPath.getBounds();
    canvas.drawPath(
      crownPath.shift(Offset(0, size.height * 0.014)),
      Paint()..color = Colors.black.withValues(alpha: 0.16),
    );
    canvas.drawPath(
      crownPath,
      Paint()
        ..shader = LinearGradient(
          colors: [goldBright, const Color(0xFFF3CC76), gold],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(crownBounds),
    );

    final baseRect = Rect.fromCenter(
      center: Offset(center.dx, size.height * 0.768),
      width: size.width * 0.07,
      height: size.height * 0.11,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(baseRect, Radius.circular(size.width * 0.02)),
      Paint()
        ..shader = LinearGradient(
          colors: [goldBright.withValues(alpha: 0.88), gold],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(baseRect),
    );

    final flameOuter = Path()
      ..moveTo(center.dx, size.height * 0.29)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.43,
        size.width * 0.36,
        size.height * 0.62,
        size.width * 0.46,
        size.height * 0.735,
      )
      ..quadraticBezierTo(
        center.dx,
        size.height * 0.8,
        size.width * 0.54,
        size.height * 0.735,
      )
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.62,
        size.width * 0.65,
        size.height * 0.43,
        center.dx,
        size.height * 0.29,
      )
      ..close();
    final flameBounds = flameOuter.getBounds();
    canvas.drawPath(
      flameOuter.shift(Offset(0, size.height * 0.02)),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );
    canvas.drawPath(
      flameOuter,
      Paint()
        ..shader = LinearGradient(
          colors: [ivory, const Color(0xFFF9F0E6), const Color(0xFFE7DCCF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(flameBounds),
    );
    canvas.drawPath(
      flameOuter,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.01
        ..color = goldBright.withValues(alpha: 0.16),
    );

    final flameInner = Path()
      ..moveTo(center.dx, size.height * 0.44)
      ..cubicTo(
        size.width * 0.468,
        size.height * 0.53,
        size.width * 0.46,
        size.height * 0.64,
        center.dx,
        size.height * 0.71,
      )
      ..cubicTo(
        size.width * 0.54,
        size.height * 0.64,
        size.width * 0.532,
        size.height * 0.53,
        center.dx,
        size.height * 0.44,
      )
      ..close();
    canvas.drawPath(
      flameInner,
      Paint()
        ..shader = LinearGradient(
          colors: [goldBright, const Color(0xFFF4CE78), gold],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(flameInner.getBounds()),
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: medallionRadius * 0.88),
      math.pi * 0.12,
      math.pi * 0.76,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.008
        ..color = Colors.white.withValues(alpha: 0.12),
    );
  }

  @override
  bool shouldRepaint(covariant _BrandPainter oldDelegate) {
    return oldDelegate.gold != gold ||
        oldDelegate.goldBright != goldBright ||
        oldDelegate.copper != copper ||
        oldDelegate.mint != mint ||
        oldDelegate.ivory != ivory;
  }
}
