import 'package:flutter/material.dart';

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 24,
    this.tint,
    this.borderOpacity = 0.5,
    this.fillOpacity,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? tint;
  final double borderOpacity;
  final double? fillOpacity;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = tint ?? scheme.outline;
    final resolvedFillOpacity =
        fillOpacity ?? (theme.brightness == Brightness.dark ? 0.9 : 0.95);
    final resolvedGradient =
        gradient ??
        LinearGradient(
          colors: [
            scheme.surface.withValues(alpha: resolvedFillOpacity),
            scheme.surface.withValues(
              alpha: (resolvedFillOpacity - 0.08).clamp(0.72, 0.98).toDouble(),
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Material(
      color: Colors.transparent,
      child: Ink(
        padding: padding,
        decoration: BoxDecoration(
          gradient: resolvedGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: accent.withValues(alpha: borderOpacity + 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.16 : 0.06,
              ),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
