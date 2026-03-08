import '../domain/app_user.dart';
import '../domain/auth_device_session.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_response.dart';
import '../domain/auth_session.dart';
import '../domain/auth_token_bundle.dart';

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository({
    required List<AppUser> users,
    Map<String, String>? passwords,
    AuthSession? initialSession,
  }) : _users = <String, AppUser>{
         for (final user in users) user.username: user,
       },
       _passwords = passwords ?? DevPasswords.defaults,
       _session = initialSession;

  final Map<String, AppUser> _users;
  final Map<String, String> _passwords;
  AuthSession? _session;
  final List<AuthDeviceSession> _devices = <AuthDeviceSession>[
    AuthDeviceSession(
      id: 'memory-current-device',
      deviceName: 'Widget Test Device',
      platformLabel: 'Test',
      lastActiveAt: DateTime(2026, 3, 7, 12),
      isCurrent: true,
    ),
  ];

  @override
  Future<AuthSession?> restoreSession() async => _session;

  @override
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final user = _users[username];
    if (user == null || _passwords[username] != password) {
      return const AuthResponse.failure(AuthFailure.invalidCredentials);
    }

    _session = AuthSession(
      user: user,
      signedInAt: DateTime(2026, 3, 7, 12),
      tokens: AuthTokenBundle(
        accessToken: 'memory-access-$username',
        refreshToken: 'memory-refresh-$username',
        expiresAt: DateTime(2026, 3, 7, 20),
        sessionId: 'memory-session-$username',
      ),
    );
    return AuthResponse.success(_session!);
  }

  @override
  Future<AuthResponse> register({
    required String username,
    required String password,
    required String displayName,
  }) async {
    final normalizedUsername = username.trim().toLowerCase();
    if (normalizedUsername.length < 3) {
      return const AuthResponse.failure(AuthFailure.invalidCredentials);
    }
    if (_users.containsKey(normalizedUsername)) {
      return const AuthResponse.failure(AuthFailure.usernameTaken);
    }
    if (password.length < 8) {
      return const AuthResponse.failure(AuthFailure.weakPassword);
    }

    final now = DateTime.now();
    final uidTail = now.microsecondsSinceEpoch.remainder(9000) + 1000;
    final created = AppUser(
      id: 'player-${now.microsecondsSinceEpoch}',
      username: normalizedUsername,
      displayName: displayName.trim().isEmpty
          ? normalizedUsername
          : displayName.trim(),
      role: AppUserRole.player,
      uid: 'EPC-$uidTail',
      level: 1,
      bio: 'New player',
      avatarSeed: uidTail % 8,
      email: '$normalizedUsername@ember.club',
      provider: AuthProvider.usernamePassword,
    );

    _users[normalizedUsername] = created;
    _passwords[normalizedUsername] = password;

    _session = AuthSession(
      user: created,
      signedInAt: now,
      tokens: AuthTokenBundle(
        accessToken: 'memory-access-$normalizedUsername',
        refreshToken: 'memory-refresh-$normalizedUsername',
        expiresAt: now.add(const Duration(hours: 8)),
        sessionId: 'memory-session-$normalizedUsername',
      ),
    );
    return AuthResponse.success(_session!);
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  Future<AppUser> updateProfile({
    required String displayName,
    required String bio,
    required int avatarSeed,
  }) async {
    final session = _session;
    if (session == null) {
      throw StateError('No authenticated session.');
    }
    final updated = session.user.copyWith(
      displayName: displayName,
      bio: bio,
      avatarSeed: avatarSeed,
    );
    _users[updated.username] = updated;
    _session = session.copyWith(user: updated);
    return updated;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    final session = _session;
    if (session == null) {
      throw StateError(AuthFailure.unauthorized.name);
    }
    if (_passwords[session.user.username] != currentPassword) {
      throw StateError(AuthFailure.incorrectPassword.name);
    }
    if (nextPassword.length < 8) {
      throw StateError(AuthFailure.weakPassword.name);
    }
    _passwords[session.user.username] = nextPassword;
  }

  @override
  Future<List<AuthDeviceSession>> fetchDeviceSessions() async =>
      List<AuthDeviceSession>.unmodifiable(_devices);

  @override
  Future<void> signOutDevice(String deviceSessionId) async {
    _devices.removeWhere(
      (device) => device.id == deviceSessionId && !device.isCurrent,
    );
  }
}

class DevPasswords {
  static final defaults = <String, String>{
    'ember_admin': 'Ember#2026!',
    'captain_demo': 'Captain#2026!',
  };
}
