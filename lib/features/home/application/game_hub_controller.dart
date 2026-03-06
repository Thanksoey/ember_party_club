import 'package:flutter/foundation.dart';

import '../../../core/models/game_module.dart';

class GameHubController extends ChangeNotifier {
  GameHubController.seeded(List<GameModule> modules)
      : _allModules = List.unmodifiable(modules),
        _selectedCategory = null;

  final List<GameModule> _allModules;
  GameCategory? _selectedCategory;

  List<GameModule> get featuredModules =>
      _allModules.where((module) => module.isFeatured).toList(growable: false);

  GameCategory? get selectedCategory => _selectedCategory;

  List<GameModule> get visibleModules {
    final category = _selectedCategory;
    if (category == null) {
      return _allModules;
    }

    return _allModules
        .where((module) => module.category == category)
        .toList(growable: false);
  }

  List<GameCategory> get categories => GameCategory.values;

  void toggleCategory(GameCategory category) {
    _selectedCategory = _selectedCategory == category ? null : category;
    notifyListeners();
  }
}

