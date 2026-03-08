import 'dart:math';

import '../../domain/app_user.dart';
import '../../domain/auth_device_session.dart';
import '../../domain/auth_failure.dart';
import '../dev_seed_auth_repository.dart';
import 'auth_api_client.dart';
import 'auth_api_models.dart';

class MockAuthApiClient implements AuthApiClient {
  MockAuthApiClient() {
    for (final user in DevSeedAuthRepository.seededUsers) {
      _users[user.username] = user;
    }
  }

  final Map<String, AppUser> _users = <String, AppUser>{};
  final Map<String, String> _passwords = Map<String, String>.from(
    DevSeedAuthRepository.seededPasswords,
  );
  final Map<String, String> _sessionByRefreshToken = <String, String>{};
  final Map<String, AuthApiSessionPayload> _sessions =
      <String, AuthApiSessionPayload>{};
  final Map<String, List<AuthDeviceSession>> _devicesByUser =
      <String, List<AuthDeviceSession>>{};
  final Random _random = Random(23);

  @override
  Future<AuthApiSessionPayload> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    final user = _users[username];
    if (user == null || _passwords[username] != password) {
      throw const AuthApiException(AuthFailure.invalidCredentials);
    }

    final payload = _issueSession(user);
    _registerDevice(user, payload.tokens.sessionId);
    return payload;
  }

  @override
  Future<AuthApiSessionPayload> register({
    required String username,
    required String password,
    required String displayName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final normalizedUsername = username.trim().toLowerCase();
    if (normalizedUsername.length < 3) {
      throw const AuthApiException(AuthFailure.invalidCredentials);
    }
    if (_users.containsKey(normalizedUsername)) {
      throw const AuthApiException(AuthFailure.usernameTaken);
    }
    if (password.length < 8) {
      throw const AuthApiException(AuthFailure.weakPassword);
    }

    final user = _buildPlayer(
      username: normalizedUsername,
      displayName: displayName.trim(),
    );
    _users[normalizedUsername] = user;
    _passwords[normalizedUsername] = password;

    final payload = _issueSession(user);
    _registerDevice(user, payload.tokens.sessionId);
    return payload;
  }

  @override
  Future<AuthApiSessionPayload> refreshSession({
    required String refreshToken,
    required String sessionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    final boundSessionId = _sessionByRefreshToken[refreshToken];
    if (boundSessionId == null || boundSessionId != sessionId) {
      throw const AuthApiException(AuthFailure.sessionExpired);
    }

    final current = _sessions[sessionId];
    if (current == null) {
      throw const AuthApiException(AuthFailure.sessionExpired);
    }

    final refreshed = _issueSession(current.user, sessionId: sessionId);
    _registerDevice(current.user, sessionId);
    return refreshed;
  }

  @override
  Future<AuthApiSessionPayload> updateProfile({
    required String accessToken,
    required AuthApiProfileUpdatePayload payload,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final session = _resolveSession(accessToken);
    final updatedUser = session.user.copyWith(
      displayName: payload.displayName,
      bio: payload.bio,
      avatarSeed: payload.avatarSeed,
    );
    _users[updatedUser.username] = updatedUser;
    final updatedSession = AuthApiSessionPayload(
      user: updatedUser,
      tokens: session.tokens,
      signedInAt: session.signedInAt,
    );
    _sessions[session.tokens.sessionId] = updatedSession;
    return updatedSession;
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required AuthApiChangePasswordPayload payload,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    final session = _resolveSession(accessToken);
    final username = session.user.username;
    if (_passwords[username] != payload.currentPassword) {
      throw const AuthApiException(AuthFailure.incorrectPassword);
    }
    if (payload.nextPassword.length < 8) {
      throw const AuthApiException(AuthFailure.weakPassword);
    }
    _passwords[username] = payload.nextPassword;
  }

  @override
  Future<AuthApiDeviceListPayload> fetchDevices({
    required String accessToken,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    final session = _resolveSession(accessToken);
    final devices = _devicesByUser[session.user.id] ?? <AuthDeviceSession>[];
    return AuthApiDeviceListPayload(
      devices: List<AuthDeviceSession>.unmodifiable(
        devices.map(
          (device) => AuthDeviceSession(
            id: device.id,
            deviceName: device.deviceName,
            platformLabel: device.platformLabel,
            lastActiveAt: DateTime.now(),
            isCurrent: device.id == session.tokens.sessionId,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> revokeDevice({
    required String accessToken,
    required String deviceSessionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    final session = _resolveSession(accessToken);
    final devices = _devicesByUser[session.user.id] ?? <AuthDeviceSession>[];
    _devicesByUser[session.user.id] = devices
        .where(
          (device) =>
              device.id == session.tokens.sessionId ||
              device.id != deviceSessionId,
        )
        .toList(growable: false);
  }

  AuthApiSessionPayload _resolveSession(String accessToken) {
    for (final session in _sessions.values) {
      if (session.tokens.accessToken == accessToken) {
        if (session.tokens.expiresAt.isBefore(DateTime.now())) {
          throw const AuthApiException(AuthFailure.sessionExpired);
        }
        return session;
      }
    }
    throw const AuthApiException(AuthFailure.unauthorized);
  }

  AuthApiSessionPayload _issueSession(AppUser user, {String? sessionId}) {
    final resolvedSessionId =
        sessionId ??
        'session-${user.id}-${DateTime.now().millisecondsSinceEpoch}-${_random.nextInt(999)}';
    final tokens = AuthApiTokenPayload(
      accessToken: 'access-$resolvedSessionId',
      refreshToken: 'refresh-$resolvedSessionId',
      sessionId: resolvedSessionId,
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
    );
    final payload = AuthApiSessionPayload(
      user: user,
      tokens: tokens,
      signedInAt: DateTime.now(),
    );
    _sessionByRefreshToken[tokens.refreshToken] = resolvedSessionId;
    _sessions[resolvedSessionId] = payload;
    return payload;
  }

  void _registerDevice(AppUser user, String sessionId) {
    final devices =
        _devicesByUser[user.id] ??
        <AuthDeviceSession>[
          AuthDeviceSession(
            id: 'device-ios-shadow',
            deviceName: 'Xiaomi 15',
            platformLabel: 'Android',
            lastActiveAt: DateTime.now().subtract(const Duration(minutes: 18)),
            isCurrent: false,
          ),
        ];
    final updatedDevices = <AuthDeviceSession>[
      AuthDeviceSession(
        id: sessionId,
        deviceName: 'Codex Dev Shell',
        platformLabel: 'Windows',
        lastActiveAt: DateTime.now(),
        isCurrent: true,
      ),
      ...devices.where((device) => device.id != sessionId),
    ];
    _devicesByUser[user.id] = updatedDevices;
  }

  AppUser _buildPlayer({
    required String username,
    required String displayName,
  }) {
    final now = DateTime.now();
    final uidTail = now.microsecondsSinceEpoch.remainder(9000) + 1000;
    return AppUser(
      id: 'player-${now.microsecondsSinceEpoch}',
      username: username,
      displayName: displayName.isEmpty ? username : displayName,
      role: AppUserRole.player,
      uid: 'EPC-$uidTail',
      level: 1,
      bio: 'New party player',
      avatarSeed: uidTail % 8,
      email: '$username@ember.club',
      provider: AuthProvider.usernamePassword,
    );
  }
}
