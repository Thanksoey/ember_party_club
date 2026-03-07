import 'package:flutter/foundation.dart';

import '../../../core/models/game_module.dart';
import '../../modules/application/game_module_registry.dart';

class GameHubController extends ChangeNotifier {
  GameHubController({required GameModuleRegistry registry}) : _registry = registry;

  final GameModuleRegistry _registry;
  GameCategory? _selectedCategory;

  List<GameModule> get featuredModules => _registry.featuredModules;

  GameCategory? get selectedCategory => _selectedCategory;

  List<GameModule> get visibleModules => _registry.byCategory(_selectedCategory);

  List<GameCategory> get categories => _registry.categories;

  int get totalModuleCount => _registry.allModules.length;

  int get featuredCount => featuredModules.length;

  void toggleCategory(GameCategory category) {
    _selectedCategory = _selectedCategory == category ? null : category;
    notifyListeners();
  }
}
