import '../../../core/storage/app_preference_store.dart';
import '../domain/app_user.dart';
import '../domain/auth_device_session.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_response.dart';
import '../domain/auth_session.dart';
import 'auth_api.dart';
import 'dev_seed_auth_api.dart';

class DevSeedAuthRepository implements AuthRepository {
  DevSeedAuthRepository({required AppPreferenceStore store, AuthApi? api})
    : _store = store,
      _api = api ?? DevSeedAuthApi(store: store);

  static const _sessionUsernameKey = 'auth.session.username';
  static const _sessionRefreshTokenKey = 'auth.session.refresh_token';
  static const _sessionSignedInAtKey = 'auth.session.signed_in_at';

  static const seededUsers = DevSeedAuthApi.seededUsers;
  static const seededPasswords = DevSeedAuthApi.seededPasswords;

  final AppPreferenceStore _store;
  final AuthApi _api;
  AuthSession? _cachedSession;

  @override
  Future<AuthSession?> restoreSession() async {
    final refreshToken = await _store.readSecretString(_sessionRefreshTokenKey);
    final username = await _store.readString(_sessionUsernameKey);
    if (refreshToken == null || username == null) {
      return null;
    }

    final response = await _api.refreshSession(refreshToken: refreshToken);
    if (!response.isSuccess) {
      await _clearStoredSession();
      return null;
    }
    await _persistSession(response.session!);
    return _cachedSession;
  }

  @override
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _api.login(username: username, password: password);
    if (response.isSuccess) {
      await _persistSession(response.session!);
    }
    return response;
  }

  @override
  Future<AuthResponse> register({
    required String username,
    required String password,
    required String displayName,
  }) async {
    final response = await _api.register(
      username: username,
      password: password,
      displayName: displayName,
    );
    if (response.isSuccess) {
      await _persistSession(response.session!);
    }
    return response;
  }

  @override
  Future<void> logout() async {
    final session = await _ensureSession();
    if (session != null) {
      await _api.logout(session: session);
    }
    await _clearStoredSession();
  }

  @override
  Future<AppUser> updateProfile({
    required String displayName,
    required String bio,
    required int avatarSeed,
  }) async {
    final session = await _requireSession();
    final updatedUser = await _api.updateProfile(
      session: session,
      displayName: displayName,
      bio: bio,
      avatarSeed: avatarSeed,
    );
    final nextSession = session.copyWith(user: updatedUser);
    await _persistSession(nextSession);
    return updatedUser;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    final session = await _requireSession();
    await _api.changePassword(
      session: session,
      currentPassword: currentPassword,
      nextPassword: nextPassword,
    );
  }

  @override
  Future<List<AuthDeviceSession>> fetchDeviceSessions() async {
    final session = await _requireSession();
    return _api.fetchDeviceSessions(session: session);
  }

  @override
  Future<void> signOutDevice(String deviceSessionId) async {
    final session = await _requireSession();
    await _api.signOutDevice(
      session: session,
      deviceSessionId: deviceSessionId,
    );
  }

  Future<AuthSession> _requireSession() async {
    final session = await _ensureSession();
    if (session == null) {
      throw StateError('No authenticated session.');
    }
    return session;
  }

  Future<AuthSession?> _ensureSession() async {
    final session = _cachedSession;
    if (session == null) {
      return restoreSession();
    }
    if (!session.isExpired) {
      return session;
    }
    return restoreSession();
  }

  Future<void> _persistSession(AuthSession session) async {
    _cachedSession = session;
    await _store.writeString(_sessionUsernameKey, session.user.username);
    await _store.writeSecretString(
      _sessionRefreshTokenKey,
      session.tokens.refreshToken,
    );
    await _store.writeString(
      _sessionSignedInAtKey,
      session.signedInAt.toIso8601String(),
    );
  }

  Future<void> _clearStoredSession() async {
    _cachedSession = null;
    await _store.remove(_sessionUsernameKey);
    await _store.remove(_sessionSignedInAtKey);
    await _store.removeSecret(_sessionRefreshTokenKey);
  }
}
