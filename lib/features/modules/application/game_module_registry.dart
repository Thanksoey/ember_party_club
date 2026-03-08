import '../../../core/models/game_module.dart';

class GameModuleRegistry {
  GameModuleRegistry.seeded(List<GameModule> modules)
    : _modules = List.unmodifiable(modules);

  final List<GameModule> _modules;

  List<GameModule> get allModules => _modules;

  List<GameModule> get featuredModules =>
      _modules.where((module) => module.isFeatured).toList(growable: false);

  List<GameCategory> get categories => GameCategory.values;

  List<GameModule> byCategory(GameCategory? category) {
    if (category == null) {
      return _modules;
    }

    return _modules
        .where((module) => module.category == category)
        .toList(growable: false);
  }

  GameModule? findById(String moduleId) {
    for (final module in _modules) {
      if (module.id == moduleId) {
        return module;
      }
    }

    return null;
  }
}
