import 'dart:convert';

import '../../../core/storage/app_preference_store.dart';
import '../domain/app_user.dart';
import '../domain/auth_device_session.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_response.dart';
import '../domain/auth_session.dart';
import '../domain/auth_token_bundle.dart';

class DevSeedAuthRepository implements AuthRepository {
  DevSeedAuthRepository({required AppPreferenceStore store}) : _store = store;

  static const _sessionUserKey = 'auth.session.username';
  static const _sessionIdKey = 'auth.session.id';
  static const _deviceListKey = 'auth.devices';

  static final seededUsers = <AppUser>[
    const AppUser(
      id: 'admin-001',
      username: 'ember_admin',
      displayName: 'Ember Admin',
      role: AppUserRole.admin,
      uid: 'EPC-9001',
      level: 42,
      bio: '维护房间秩序、检查配置与运营面板的系统管理员。',
      avatarSeed: 2,
      email: 'admin@ember.club',
      provider: AuthProvider.usernamePassword,
    ),
    const AppUser(
      id: 'player-001',
      username: 'captain_demo',
      displayName: 'Captain Nova',
      role: AppUserRole.player,
      uid: 'EPC-1288',
      level: 18,
      bio: '偏爱卡牌与推理房，负责首轮试玩反馈。',
      avatarSeed: 7,
      email: 'captain@ember.club',
      provider: AuthProvider.usernamePassword,
    ),
  ];

  static final _passwords = <String, String>{
    'ember_admin': 'Ember#2026!',
    'captain_demo': 'Captain#2026!',
  };

  final AppPreferenceStore _store;

  final Map<String, AppUser> _usersByUsername = <String, AppUser>{
    for (final user in seededUsers) user.username: user,
  };

  @override
  Future<AuthSession?> restoreSession() async {
    final username = await _store.readString(_sessionUserKey);
    if (username == null) {
      return null;
    }

    final user = _usersByUsername[username];
    if (user == null) {
      await logout();
      return null;
    }

    final refreshToken = await _store.readSecretString('auth.refresh.$username');
    if (refreshToken == null) {
      await logout();
      return null;
    }

    final sessionId = await _store.readString(_sessionIdKey) ?? 'session-$username';
    return _sessionFor(user, sessionId: sessionId, refreshToken: refreshToken);
  }

  @override
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final user = _usersByUsername[username];
    if (user == null || _passwords[username] != password) {
      return const AuthResponse.failure(AuthFailure.invalidCredentials);
    }

    final sessionId = 'session-${DateTime.now().millisecondsSinceEpoch}';
    final session = _sessionFor(
      user,
      sessionId: sessionId,
      refreshToken: 'refresh-$sessionId-${user.id}',
    );
    await _persistSession(session);
    await _upsertCurrentDevice(session.tokens.sessionId);
    return AuthResponse.success(session);
  }

  @override
  Future<void> logout() async {
    final username = await _store.readString(_sessionUserKey);
    if (username != null) {
      await _store.removeSecret('auth.refresh.$username');
    }
    await _store.remove(_sessionUserKey);
    await _store.remove(_sessionIdKey);
  }

  @override
  Future<AppUser> updateProfile({
    required String displayName,
    required String bio,
    required int avatarSeed,
  }) async {
    final username = await _store.readString(_sessionUserKey);
    if (username == null) {
      throw StateError('No authenticated user.');
    }
    final current = _usersByUsername[username];
    if (current == null) {
      throw StateError('Seeded user not found.');
    }
    final updated = current.copyWith(
      displayName: displayName,
      bio: bio,
      avatarSeed: avatarSeed,
    );
    _usersByUsername[username] = updated;
    return updated;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    final username = await _store.readString(_sessionUserKey);
    if (username == null) {
      throw StateError(AuthFailure.unauthorized.name);
    }
    if (_passwords[username] != currentPassword) {
      throw StateError(AuthFailure.incorrectPassword.name);
    }
    if (nextPassword.length < 8) {
      throw StateError(AuthFailure.weakPassword.name);
    }
    _passwords[username] = nextPassword;
  }

  @override
  Future<List<AuthDeviceSession>> fetchDeviceSessions() async {
    final raw = await _store.readString(_deviceListKey);
    if (raw == null || raw.isEmpty) {
      return <AuthDeviceSession>[
        AuthDeviceSession(
          id: 'local-dev-shell',
          deviceName: 'Codex Dev Shell',
          platformLabel: 'Windows',
          lastActiveAt: DateTime.now(),
          isCurrent: true,
        ),
      ];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((item) {
      final map = item as Map<String, dynamic>;
      return AuthDeviceSession(
        id: map['id'] as String,
        deviceName: map['deviceName'] as String,
        platformLabel: map['platformLabel'] as String,
        lastActiveAt: DateTime.parse(map['lastActiveAt'] as String),
        isCurrent: map['isCurrent'] as bool,
      );
    }).toList(growable: false);
  }

  @override
  Future<void> signOutDevice(String deviceSessionId) async {
    final devices = await fetchDeviceSessions();
    final filtered = devices.where((device) => device.id != deviceSessionId || device.isCurrent).toList(growable: false);
    await _store.writeString(
      _deviceListKey,
      jsonEncode(
        filtered
            .map(
              (device) => <String, Object>{
                'id': device.id,
                'deviceName': device.deviceName,
                'platformLabel': device.platformLabel,
                'lastActiveAt': device.lastActiveAt.toIso8601String(),
                'isCurrent': device.isCurrent,
              },
            )
            .toList(growable: false),
      ),
    );
  }

  AuthSession _sessionFor(
    AppUser user, {
    required String sessionId,
    required String refreshToken,
  }) {
    return AuthSession(
      user: user,
      signedInAt: DateTime.now(),
      tokens: AuthTokenBundle(
        accessToken: 'access-$sessionId-${user.id}',
        refreshToken: refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 8)),
        sessionId: sessionId,
      ),
    );
  }

  Future<void> _persistSession(AuthSession session) async {
    await _store.writeString(_sessionUserKey, session.user.username);
    await _store.writeString(_sessionIdKey, session.tokens.sessionId);
    await _store.writeSecretString(
      'auth.refresh.${session.user.username}',
      session.tokens.refreshToken,
    );
  }

  Future<void> _upsertCurrentDevice(String sessionId) async {
    final current = AuthDeviceSession(
      id: sessionId,
      deviceName: 'Codex Dev Shell',
      platformLabel: 'Windows',
      lastActiveAt: DateTime.now(),
      isCurrent: true,
    );
    final devices = await fetchDeviceSessions();
    final others = devices.where((device) => !device.isCurrent && device.id != current.id).toList(growable: false);
    await _store.writeString(
      _deviceListKey,
      jsonEncode(
        <Map<String, Object>>[
          {
            'id': current.id,
            'deviceName': current.deviceName,
            'platformLabel': current.platformLabel,
            'lastActiveAt': current.lastActiveAt.toIso8601String(),
            'isCurrent': true,
          },
          ...others.map(
            (device) => <String, Object>{
              'id': device.id,
              'deviceName': device.deviceName,
              'platformLabel': device.platformLabel,
              'lastActiveAt': device.lastActiveAt.toIso8601String(),
              'isCurrent': false,
            },
          ),
        ],
      ),
    );
  }
}
