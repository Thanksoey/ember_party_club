import '../../../../core/storage/app_preference_store.dart';
import '../../domain/app_user.dart';
import '../../domain/auth_device_session.dart';
import '../../domain/auth_failure.dart';
import '../../domain/auth_repository.dart';
import '../../domain/auth_response.dart';
import '../../domain/auth_session.dart';
import '../../domain/auth_token_bundle.dart';
import 'auth_api_client.dart';
import 'auth_api_models.dart';

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository({
    required AuthApiClient client,
    required AppPreferenceStore store,
  }) : _client = client,
       _store = store;

  static const _refreshTokenKey = 'auth.refresh.token';
  static const _sessionIdKey = 'auth.session.id';
  static const _accessTokenKey = 'auth.access.token';

  final AuthApiClient _client;
  final AppPreferenceStore _store;
  AuthSession? _activeSession;

  @override
  Future<AuthSession?> restoreSession() async {
    final refreshToken = await _store.readSecretString(_refreshTokenKey);
    final sessionId = await _store.readString(_sessionIdKey);
    if (refreshToken == null || sessionId == null) {
      return null;
    }

    try {
      final payload = await _client.refreshSession(
        refreshToken: refreshToken,
        sessionId: sessionId,
      );
      final session = _mapSession(payload);
      await _persistSession(session);
      _activeSession = session;
      return session;
    } on AuthApiException catch (_) {
      await _clearSession();
      return null;
    }
  }

  @override
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final payload = await _client.login(
        username: username,
        password: password,
      );
      final session = _mapSession(payload);
      await _persistSession(session);
      _activeSession = session;
      return AuthResponse.success(session);
    } on AuthApiException catch (error) {
      return AuthResponse.failure(error.failure);
    }
  }

  @override
  Future<AuthResponse> register({
    required String username,
    required String password,
    required String displayName,
  }) async {
    try {
      final payload = await _client.register(
        username: username,
        password: password,
        displayName: displayName,
      );
      final session = _mapSession(payload);
      await _persistSession(session);
      _activeSession = session;
      return AuthResponse.success(session);
    } on AuthApiException catch (error) {
      return AuthResponse.failure(error.failure);
    }
  }

  @override
  Future<void> logout() async {
    _activeSession = null;
    await _clearSession();
  }

  @override
  Future<AppUser> updateProfile({
    required String displayName,
    required String bio,
    required int avatarSeed,
  }) async {
    final accessToken = await _requireAccessToken();
    try {
      final payload = await _client.updateProfile(
        accessToken: accessToken,
        payload: AuthApiProfileUpdatePayload(
          displayName: displayName,
          bio: bio,
          avatarSeed: avatarSeed,
        ),
      );
      final session = _mapSession(payload);
      await _persistSession(session);
      _activeSession = session;
      return session.user;
    } on AuthApiException catch (error) {
      throw StateError(error.failure.name);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    final accessToken = await _requireAccessToken();
    try {
      await _client.changePassword(
        accessToken: accessToken,
        payload: AuthApiChangePasswordPayload(
          currentPassword: currentPassword,
          nextPassword: nextPassword,
        ),
      );
    } on AuthApiException catch (error) {
      throw StateError(error.failure.name);
    }
  }

  @override
  Future<List<AuthDeviceSession>> fetchDeviceSessions() async {
    final accessToken = await _requireAccessToken();
    try {
      final payload = await _client.fetchDevices(accessToken: accessToken);
      return payload.devices;
    } on AuthApiException catch (error) {
      throw StateError(error.failure.name);
    }
  }

  @override
  Future<void> signOutDevice(String deviceSessionId) async {
    final accessToken = await _requireAccessToken();
    try {
      await _client.revokeDevice(
        accessToken: accessToken,
        deviceSessionId: deviceSessionId,
      );
    } on AuthApiException catch (error) {
      throw StateError(error.failure.name);
    }
  }

  Future<String> _requireAccessToken() async {
    final inMemory = _activeSession?.tokens.accessToken;
    if (inMemory != null) {
      return inMemory;
    }
    final fromStore = await _store.readSecretString(_accessTokenKey);
    if (fromStore == null) {
      throw StateError(AuthFailure.unauthorized.name);
    }
    return fromStore;
  }

  AuthSession _mapSession(AuthApiSessionPayload payload) {
    return AuthSession(
      user: payload.user,
      signedInAt: payload.signedInAt,
      tokens: AuthTokenBundle(
        accessToken: payload.tokens.accessToken,
        refreshToken: payload.tokens.refreshToken,
        expiresAt: payload.tokens.expiresAt,
        sessionId: payload.tokens.sessionId,
      ),
    );
  }

  Future<void> _persistSession(AuthSession session) async {
    await _store.writeString(_sessionIdKey, session.tokens.sessionId);
    await _store.writeSecretString(
      _refreshTokenKey,
      session.tokens.refreshToken,
    );
    await _store.writeSecretString(_accessTokenKey, session.tokens.accessToken);
  }

  Future<void> _clearSession() async {
    await _store.remove(_sessionIdKey);
    await _store.removeSecret(_refreshTokenKey);
    await _store.removeSecret(_accessTokenKey);
  }
}
