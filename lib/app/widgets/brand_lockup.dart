import 'package:flutter/material.dart';

import 'brand_mark.dart';

class BrandLockup extends StatelessWidget {
  const BrandLockup({
    super.key,
    this.badgeSize = 72,
    this.title = '余烬派对社',
    this.englishTitle = 'EMBER PARTY CLUB',
    this.caption,
    this.compact = false,
    this.center = false,
  });

  final double badgeSize;
  final String title;
  final String englishTitle;
  final String? caption;
  final bool compact;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BrandMark(size: badgeSize),
        SizedBox(width: compact ? 12 : 16),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: align,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: compact ? 18 : 20,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                englishTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: theme.textTheme.bodySmall?.copyWith(
                  letterSpacing: compact ? 1.6 : 2.2,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: 6),
                Text(
                  caption!,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: center ? TextAlign.center : TextAlign.start,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
