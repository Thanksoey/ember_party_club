import 'package:flutter/material.dart';

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

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        final selected = selectedCategory == category;

        return FilterChip(
          selected: selected,
          label: Text(category.label),
          showCheckmark: false,
          selectedColor: theme.colorScheme.primary,
          labelStyle: TextStyle(
            color: selected ? Colors.white : theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          onSelected: (_) => onCategoryTap(category),
        );
      }).toList(growable: false),
    );
  }
}

