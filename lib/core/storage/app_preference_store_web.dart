// ignore_for_file: deprecated_member_use

import 'dart:html' as html;

import 'app_preference_store.dart';

AppPreferenceStore createPreferenceStoreImpl() => WebAppPreferenceStore();

class WebAppPreferenceStore implements AppPreferenceStore {
  @override
  Future<String?> readString(String key) async => html.window.localStorage[key];

  @override
  Future<String?> readSecretString(String key) async =>
      html.window.localStorage[_secretKey(key)];

  @override
  Future<void> writeString(String key, String value) async {
    html.window.localStorage[key] = value;
  }

  @override
  Future<void> writeSecretString(String key, String value) async {
    html.window.localStorage[_secretKey(key)] = value;
  }

  @override
  Future<void> remove(String key) async {
    html.window.localStorage.remove(key);
  }

  @override
  Future<void> removeSecret(String key) async {
    html.window.localStorage.remove(_secretKey(key));
  }

  String _secretKey(String key) => 'secure.$key';
}
