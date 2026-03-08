import 'package:ember_party_club/core/storage/app_preference_store.dart';
import 'package:ember_party_club/features/auth/data/remote/mock_auth_api_client.dart';
import 'package:ember_party_club/features/auth/data/remote/remote_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'remote repository login can restore session from refresh token',
    () async {
      final store = _MemoryPreferenceStore();
      final client = MockAuthApiClient();
      final repository = RemoteAuthRepository(client: client, store: store);

      final login = await repository.login(
        username: 'captain_demo',
        password: 'Captain#2026!',
      );
      expect(login.isSuccess, isTrue);

      final restored = await RemoteAuthRepository(
        client: client,
        store: store,
      ).restoreSession();
      expect(restored, isNotNull);
      expect(restored!.user.username, 'captain_demo');
    },
  );

  test(
    'remote repository can revoke another device and keep current device',
    () async {
      final repository = RemoteAuthRepository(
        client: MockAuthApiClient(),
        store: _MemoryPreferenceStore(),
      );

      await repository.login(username: 'ember_admin', password: 'Ember#2026!');
      final devices = await repository.fetchDeviceSessions();
      final removable = devices.firstWhere((device) => !device.isCurrent);

      await repository.signOutDevice(removable.id);
      final nextDevices = await repository.fetchDeviceSessions();

      expect(nextDevices.any((device) => device.id == removable.id), isFalse);
      expect(nextDevices.any((device) => device.isCurrent), isTrue);
    },
  );
}

class _MemoryPreferenceStore implements AppPreferenceStore {
  final Map<String, String> _memory = <String, String>{};

  @override
  Future<String?> readSecretString(String key) async => _memory['secure.$key'];

  @override
  Future<String?> readString(String key) async => _memory[key];

  @override
  Future<void> remove(String key) async {
    _memory.remove(key);
  }

  @override
  Future<void> removeSecret(String key) async {
    _memory.remove('secure.$key');
  }

  @override
  Future<void> writeSecretString(String key, String value) async {
    _memory['secure.$key'] = value;
  }

  @override
  Future<void> writeString(String key, String value) async {
    _memory[key] = value;
  }
}
