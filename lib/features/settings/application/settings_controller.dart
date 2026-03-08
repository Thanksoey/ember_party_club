import 'package:flutter/material.dart';

import '../../../core/storage/app_preference_store.dart';

enum AppLocaleMode { system, chinese, english }

class SettingsController extends ChangeNotifier {
  SettingsController._(
    this._store,
    this._themeMode,
    this._localeMode,
    this._soundEffectsEnabled,
    this._hapticsEnabled,
  );

  factory SettingsController.test({
    ThemeMode themeMode = ThemeMode.system,
    AppLocaleMode localeMode = AppLocaleMode.system,
    bool soundEffectsEnabled = true,
    bool hapticsEnabled = true,
  }) {
    return SettingsController._(
      _MemoryPreferenceStore(),
      themeMode,
      localeMode,
      soundEffectsEnabled,
      hapticsEnabled,
    );
  }

  static const _themeModeKey = 'settings.theme.mode';
  static const _localeModeKey = 'settings.locale.mode';
  static const _soundEffectsKey = 'settings.feedback.sound';
  static const _hapticsKey = 'settings.feedback.haptics';

  final AppPreferenceStore _store;
  ThemeMode _themeMode;
  AppLocaleMode _localeMode;
  bool _soundEffectsEnabled;
  bool _hapticsEnabled;

  ThemeMode get themeMode => _themeMode;
  AppLocaleMode get localeMode => _localeMode;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

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
    final soundRaw = await store.readString(_soundEffectsKey);
    final hapticsRaw = await store.readString(_hapticsKey);
    return SettingsController._(
      store,
      _parseThemeMode(themeRaw),
      _parseLocaleMode(localeRaw),
      _parseBoolOrDefault(soundRaw, defaultValue: true),
      _parseBoolOrDefault(hapticsRaw, defaultValue: true),
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

  Future<void> updateSoundEffectsEnabled(bool enabled) async {
    if (_soundEffectsEnabled == enabled) {
      return;
    }
    _soundEffectsEnabled = enabled;
    await _store.writeString(_soundEffectsKey, enabled ? 'true' : 'false');
    notifyListeners();
  }

  Future<void> updateHapticsEnabled(bool enabled) async {
    if (_hapticsEnabled == enabled) {
      return;
    }
    _hapticsEnabled = enabled;
    await _store.writeString(_hapticsKey, enabled ? 'true' : 'false');
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

  static bool _parseBoolOrDefault(String? value, {required bool defaultValue}) {
    switch (value) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return defaultValue;
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
