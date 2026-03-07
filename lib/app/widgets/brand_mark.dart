import 'package:flutter/material.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.size = 72,
    this.showWordmark = false,
  });

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8A65), Color(0xFF0D3B66), Color(0xFF3D8D7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _BrandPainter(),
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
            Text('EMBER', style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 1.6)),
            Text('PARTY CLUB', style: theme.textTheme.bodyMedium?.copyWith(letterSpacing: 2.2)),
          ],
        ),
      ],
    );
  }
}

class _BrandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final emberPaint = Paint()..color = Colors.white.withValues(alpha: 0.92);
    final flarePaint = Paint()..color = const Color(0xFFFFD8B0).withValues(alpha: 0.95);

    final center = Offset(size.width * 0.52, size.height * 0.52);
    final path = Path()
      ..moveTo(center.dx - size.width * 0.18, center.dy + size.height * 0.22)
      ..quadraticBezierTo(
        center.dx - size.width * 0.32,
        center.dy - size.height * 0.02,
        center.dx - size.width * 0.06,
        center.dy - size.height * 0.26,
      )
      ..quadraticBezierTo(
        center.dx + size.width * 0.1,
        center.dy - size.height * 0.38,
        center.dx + size.width * 0.18,
        center.dy - size.height * 0.08,
      )
      ..quadraticBezierTo(
        center.dx + size.width * 0.3,
        center.dy + size.height * 0.08,
        center.dx + size.width * 0.08,
        center.dy + size.height * 0.24,
      )
      ..close();

    canvas.drawPath(path, emberPaint);
    canvas.drawCircle(Offset(size.width * 0.62, size.height * 0.34), size.width * 0.08, flarePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
