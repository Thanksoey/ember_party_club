import 'package:flutter/material.dart';

class AppSkeletonBlock extends StatefulWidget {
  const AppSkeletonBlock({
    super.key,
    this.height = 16,
    this.width,
    this.radius = 12,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  State<AppSkeletonBlock> createState() => _AppSkeletonBlockState();
}

class _AppSkeletonBlockState extends State<AppSkeletonBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
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
    final base = theme.colorScheme.outline.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.2 : 0.16,
    );
    final highlight = theme.colorScheme.outline.withValues(
      alpha: theme.brightness == Brightness.dark ? 0.32 : 0.28,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.2 + (_controller.value * 2.4), 0),
              end: Alignment(-0.2 + (_controller.value * 2.4), 0),
              colors: [base, highlight, base],
              stops: const [0.1, 0.4, 0.8],
            ),
          ),
        );
      },
    );
  }
}
