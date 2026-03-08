import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations.dart';
import '../../../../core/models/game_module.dart';

class CategoryFilterRow extends StatelessWidget {
  const CategoryFilterRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
  });

  final List<GameCategory> categories;
  final GameCategory? selectedCategory;
  final ValueChanged<GameCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories
          .map((category) {
            final selected = selectedCategory == category;
            final icon = switch (category) {
              GameCategory.card => Icons.style_rounded,
              GameCategory.party => Icons.celebration_rounded,
              GameCategory.bluff => Icons.visibility_rounded,
              GameCategory.strategy => Icons.hub_rounded,
            };

            return FilterChip(
              selected: selected,
              avatar: Icon(
                icon,
                size: 18,
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
              label: Text(
                l10n.gameCategoryLabel(category),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              showCheckmark: false,
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface.withValues(
                alpha: 0.88,
              ),
              side: BorderSide(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.6),
              ),
              labelStyle: TextStyle(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
              onSelected: (_) => onCategoryTap(category),
            );
          })
          .toList(growable: false),
    );
  }
}
