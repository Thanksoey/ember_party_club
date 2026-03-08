import 'package:ember_party_club/core/storage/app_preference_store.dart';
import 'package:ember_party_club/features/auth/data/dev_seed_auth_repository.dart';
import 'package:ember_party_club/features/auth/domain/auth_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('restores a persisted session through refresh token flow', () async {
    final store = _MemoryPreferenceStore();
    final repository = DevSeedAuthRepository(store: store);

    final login = await repository.login(
      username: 'captain_demo',
      password: 'Captain#2026!',
    );
    expect(login.isSuccess, isTrue);

    final restoredRepository = DevSeedAuthRepository(store: store);
    final restored = await restoredRepository.restoreSession();

    expect(restored, isNotNull);
    expect(restored!.user.username, 'captain_demo');
    expect(restored.tokens.refreshToken, isNotEmpty);
  });

  test('returns invalid credentials for bad password', () async {
    final repository = DevSeedAuthRepository(store: _MemoryPreferenceStore());

    final login = await repository.login(
      username: 'captain_demo',
      password: 'wrong-password',
    );

    expect(login.isSuccess, isFalse);
    expect(login.failure, AuthFailure.invalidCredentials);
  });
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
