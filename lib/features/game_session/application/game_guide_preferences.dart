import '../../../core/storage/app_preference_store.dart';
import '../../../core/storage/app_preference_store_factory.dart';

class GameGuidePreferences {
  GameGuidePreferences._(this._store);

  static final GameGuidePreferences instance = GameGuidePreferences._(
    createPreferenceStore(),
  );

  static const _guideSeenPrefix = 'game.guide.seen.';

  final AppPreferenceStore _store;
  final Map<String, bool> _seenCache = <String, bool>{};

  Future<bool> shouldAutoShow(String gameId) async {
    final seen = await hasSeen(gameId);
    return !seen;
  }

  Future<bool> hasSeen(String gameId) async {
    final cached = _seenCache[gameId];
    if (cached != null) {
      return cached;
    }

    final value = await _store.readString('$_guideSeenPrefix$gameId');
    final seen = value == 'true';
    _seenCache[gameId] = seen;
    return seen;
  }

  Future<void> markSeen(String gameId) async {
    if (_seenCache[gameId] == true) {
      return;
    }

    _seenCache[gameId] = true;
    await _store.writeString('$_guideSeenPrefix$gameId', 'true');
  }
}
