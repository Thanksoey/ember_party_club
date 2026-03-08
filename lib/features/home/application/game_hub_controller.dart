import 'package:flutter/foundation.dart';

import '../../../core/models/game_module.dart';
import '../../modules/application/game_module_registry.dart';

class GameHubController extends ChangeNotifier {
  GameHubController({
    required GameModuleRegistry registry,
    Duration initialLoadingDuration = const Duration(milliseconds: 420),
  }) : _registry = registry {
    if (initialLoadingDuration <= Duration.zero) {
      _isHydrating = false;
      return;
    }
    Future<void>.delayed(initialLoadingDuration, () {
      if (_disposed) {
        return;
      }
      _isHydrating = false;
      notifyListeners();
    });
  }

  final GameModuleRegistry _registry;
  GameCategory? _selectedCategory;
  bool _isHydrating = true;
  bool _disposed = false;

  List<GameModule> get featuredModules => _registry.featuredModules;

  GameCategory? get selectedCategory => _selectedCategory;

  List<GameModule> get visibleModules =>
      _registry.byCategory(_selectedCategory);

  List<GameCategory> get categories => _registry.categories;

  int get totalModuleCount => _registry.allModules.length;

  int get featuredCount => featuredModules.length;

  bool get isHydrating => _isHydrating;

  void toggleCategory(GameCategory category) {
    _selectedCategory = _selectedCategory == category ? null : category;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
