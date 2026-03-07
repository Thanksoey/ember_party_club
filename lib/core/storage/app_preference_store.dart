abstract class AppPreferenceStore {
  Future<String?> readString(String key);
  Future<void> writeString(String key, String value);
  Future<void> remove(String key);

  Future<String?> readSecretString(String key);
  Future<void> writeSecretString(String key, String value);
  Future<void> removeSecret(String key);
}
