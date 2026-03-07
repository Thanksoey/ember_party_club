import 'package:flutter/material.dart';

import '../../../core/storage/app_preference_store.dart';

enum AppLocaleMode {
  system,
  chinese,
  english,
}

class SettingsController extends ChangeNotifier {
  SettingsController._(
    this._store,
    this._themeMode,
    this._localeMode,
  );

  factory SettingsController.test({
    ThemeMode themeMode = ThemeMode.system,
    AppLocaleMode localeMode = AppLocaleMode.system,
  }) {
    return SettingsController._(_MemoryPreferenceStore(), themeMode, localeMode);
  }

  static const _themeModeKey = 'settings.theme.mode';
  static const _localeModeKey = 'settings.locale.mode';

  final AppPreferenceStore _store;
  ThemeMode _themeMode;
  AppLocaleMode _localeMode;

  ThemeMode get themeMode => _themeMode;
  AppLocaleMode get localeMode => _localeMode;

  Locale? get localeOverride {
    switch (_localeMode) {
      case AppLocaleMode.system:
        return null;
      case AppLocaleMode.chinese:
        return const Locale('zh');
      case AppLocaleMode.english:
        return const Locale('en');
    }
  }

  static Future<SettingsController> bootstrap(AppPreferenceStore store) async {
    final themeRaw = await store.readString(_themeModeKey);
    final localeRaw = await store.readString(_localeModeKey);
    return SettingsController._(
      store,
      _parseThemeMode(themeRaw),
      _parseLocaleMode(localeRaw),
    );
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) {
      return;
    }
    _themeMode = themeMode;
    await _store.writeString(_themeModeKey, themeMode.name);
    notifyListeners();
  }

  Future<void> updateLocaleMode(AppLocaleMode localeMode) async {
    if (_localeMode == localeMode) {
      return;
    }
    _localeMode = localeMode;
    await _store.writeString(_localeModeKey, localeMode.name);
    notifyListeners();
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static AppLocaleMode _parseLocaleMode(String? value) {
    switch (value) {
      case 'chinese':
        return AppLocaleMode.chinese;
      case 'english':
        return AppLocaleMode.english;
      default:
        return AppLocaleMode.system;
    }
  }
}

class _MemoryPreferenceStore implements AppPreferenceStore {
  final Map<String, String> _memory = <String, String>{};

  @override
  Future<String?> readString(String key) async => _memory[key];

  @override
  Future<String?> readSecretString(String key) async => _memory['secure.$key'];

  @override
  Future<void> remove(String key) async {
    _memory.remove(key);
  }

  @override
  Future<void> removeSecret(String key) async {
    _memory.remove('secure.$key');
  }

  @override
  Future<void> writeString(String key, String value) async {
    _memory[key] = value;
  }

  @override
  Future<void> writeSecretString(String key, String value) async {
    _memory['secure.$key'] = value;
  }
}
