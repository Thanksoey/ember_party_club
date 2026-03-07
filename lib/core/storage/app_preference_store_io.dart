import 'dart:convert';
import 'dart:io';

import 'app_preference_store.dart';

AppPreferenceStore createPreferenceStoreImpl() => IoAppPreferenceStore();

class IoAppPreferenceStore implements AppPreferenceStore {
  IoAppPreferenceStore() : _file = File('${Directory.systemTemp.path}${Platform.pathSeparator}ember_party_club_prefs.json');

  final File _file;
  Map<String, String>? _cache;

  @override
  Future<String?> readString(String key) async {
    final map = await _readAll();
    return map[key];
  }

  @override
  Future<void> writeString(String key, String value) async {
    final map = await _readAll();
    map[key] = value;
    await _writeAll(map);
  }

  @override
  Future<void> remove(String key) async {
    final map = await _readAll();
    map.remove(key);
    await _writeAll(map);
  }

  @override
  Future<String?> readSecretString(String key) => readString(_secretKey(key));

  @override
  Future<void> writeSecretString(String key, String value) =>
      writeString(_secretKey(key), value);

  @override
  Future<void> removeSecret(String key) => remove(_secretKey(key));

  Future<Map<String, String>> _readAll() async {
    if (_cache != null) {
      return Map<String, String>.from(_cache!);
    }
    if (!await _file.exists()) {
      _cache = <String, String>{};
      return <String, String>{};
    }
    final raw = await _file.readAsString();
    if (raw.trim().isEmpty) {
      _cache = <String, String>{};
      return <String, String>{};
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _cache = decoded.map((key, value) => MapEntry(key, value as String));
    return Map<String, String>.from(_cache!);
  }

  Future<void> _writeAll(Map<String, String> map) async {
    _cache = Map<String, String>.from(map);
    await _file.writeAsString(jsonEncode(_cache));
  }

  String _secretKey(String key) => 'secure.$key';
}
