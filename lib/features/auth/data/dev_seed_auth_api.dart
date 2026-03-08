import 'dart:convert';

import '../../../core/storage/app_preference_store.dart';
import '../domain/app_user.dart';
import '../domain/auth_device_session.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_response.dart';
import '../domain/auth_session.dart';
import '../domain/auth_token_bundle.dart';
import 'auth_api.dart';

class DevSeedAuthApi implements AuthApi {
  DevSeedAuthApi({required AppPreferenceStore store}) : _store = store;

  static const _userStoreKey = 'auth.api.users';
  static const _passwordStoreKey = 'auth.api.passwords';
  static const _deviceStorePrefix = 'auth.api.devices';

  static const seededUsers = <AppUser>[
    AppUser(
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
    AppUser(
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

  static const seededPasswords = <String, String>{
    'ember_admin': 'Ember#2026!',
    'captain_demo': 'Captain#2026!',
  };

  final AppPreferenceStore _store;

  @override
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    final users = await _readUsers();
    final passwords = await _readPasswords();
    final user = users[username];
    if (user == null || passwords[username] != password) {
      return const AuthResponse.failure(AuthFailure.invalidCredentials);
    }

    final session = _buildSession(user: user);
    await _upsertCurrentDevice(session);
    return AuthResponse.success(session);
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
    if (password.length < 8) {
      return const AuthResponse.failure(AuthFailure.weakPassword);
    }

    final users = await _readUsers();
    if (users.containsKey(normalizedUsername)) {
      return const AuthResponse.failure(AuthFailure.usernameTaken);
    }

    final passwords = await _readPasswords();
    final created = _buildPlayer(
      username: normalizedUsername,
      displayName: displayName.trim(),
    );
    users[normalizedUsername] = created;
    passwords[normalizedUsername] = password;
    await _writeUsers(users);
    await _store.writeSecretString(_passwordStoreKey, jsonEncode(passwords));

    final session = _buildSession(user: created);
    await _upsertCurrentDevice(session);
    return AuthResponse.success(session);
  }

  @override
  Future<AuthResponse> refreshSession({required String refreshToken}) async {
    final token = _parseRefreshToken(refreshToken);
    if (token == null) {
      return const AuthResponse.failure(AuthFailure.sessionExpired);
    }

    final users = await _readUsers();
    final user = users[token.username];
    if (user == null) {
      return const AuthResponse.failure(AuthFailure.sessionExpired);
    }

    final session = _buildSession(user: user, sessionId: token.sessionId);
    await _upsertCurrentDevice(session);
    return AuthResponse.success(session);
  }

  @override
  Future<void> logout({required AuthSession session}) async {
    final devices = await fetchDeviceSessions(session: session);
    final nextDevices = devices
        .where((device) => device.id != session.tokens.sessionId)
        .toList(growable: false);
    await _writeDevices(session.user.username, nextDevices);
  }

  @override
  Future<AppUser> updateProfile({
    required AuthSession session,
    required String displayName,
    required String bio,
    required int avatarSeed,
  }) async {
    final users = await _readUsers();
    final current = users[session.user.username];
    if (current == null) {
      throw StateError(AuthFailure.unauthorized.name);
    }
    final updated = current.copyWith(
      displayName: displayName,
      bio: bio,
      avatarSeed: avatarSeed,
    );
    users[updated.username] = updated;
    await _writeUsers(users);
    return updated;
  }

  @override
  Future<void> changePassword({
    required AuthSession session,
    required String currentPassword,
    required String nextPassword,
  }) async {
    final passwords = await _readPasswords();
    if (passwords[session.user.username] != currentPassword) {
      throw StateError(AuthFailure.incorrectPassword.name);
    }
    if (nextPassword.length < 8) {
      throw StateError(AuthFailure.weakPassword.name);
    }
    passwords[session.user.username] = nextPassword;
    await _store.writeSecretString(_passwordStoreKey, jsonEncode(passwords));
  }

  @override
  Future<List<AuthDeviceSession>> fetchDeviceSessions({
    required AuthSession session,
  }) async {
    final raw = await _store.readString(_deviceKey(session.user.username));
    if (raw == null || raw.isEmpty) {
      final devices = _defaultDevices(
        currentSessionId: session.tokens.sessionId,
      );
      await _writeDevices(session.user.username, devices);
      return devices;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => _deviceFromMap(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<void> signOutDevice({
    required AuthSession session,
    required String deviceSessionId,
  }) async {
    final devices = await fetchDeviceSessions(session: session);
    final filtered = devices
        .where((device) => device.id != deviceSessionId || device.isCurrent)
        .toList(growable: false);
    await _writeDevices(session.user.username, filtered);
  }

  Future<Map<String, AppUser>> _readUsers() async {
    final raw = await _store.readString(_userStoreKey);
    if (raw == null || raw.isEmpty) {
      return {for (final user in seededUsers) user.username: user};
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (key, value) =>
          MapEntry(key, _userFromMap(value as Map<String, dynamic>)),
    );
  }

  Future<void> _writeUsers(Map<String, AppUser> users) async {
    await _store.writeString(
      _userStoreKey,
      jsonEncode(users.map((key, value) => MapEntry(key, _userToMap(value)))),
    );
  }

  Future<Map<String, String>> _readPasswords() async {
    final raw = await _store.readSecretString(_passwordStoreKey);
    if (raw == null || raw.isEmpty) {
      return Map<String, String>.from(seededPasswords);
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as String));
  }

  AuthSession _buildSession({required AppUser user, String? sessionId}) {
    final resolvedSessionId =
        sessionId ?? 'session-${DateTime.now().millisecondsSinceEpoch}';
    final issuedAt = DateTime.now();
    final refreshExpiry = issuedAt.add(const Duration(days: 14));
    return AuthSession(
      user: user,
      signedInAt: issuedAt,
      tokens: AuthTokenBundle(
        accessToken:
            'access|${user.username}|$resolvedSessionId|${issuedAt.add(const Duration(hours: 2)).millisecondsSinceEpoch}',
        refreshToken:
            'refresh|${user.username}|$resolvedSessionId|${refreshExpiry.millisecondsSinceEpoch}',
        expiresAt: issuedAt.add(const Duration(hours: 2)),
        sessionId: resolvedSessionId,
      ),
    );
  }

  _ParsedRefreshToken? _parseRefreshToken(String refreshToken) {
    final parts = refreshToken.split('|');
    if (parts.length != 4 || parts.first != 'refresh') {
      return null;
    }
    final expiryMillis = int.tryParse(parts[3]);
    if (expiryMillis == null) {
      return null;
    }
    final expiry = DateTime.fromMillisecondsSinceEpoch(expiryMillis);
    if (DateTime.now().isAfter(expiry)) {
      return null;
    }
    return _ParsedRefreshToken(username: parts[1], sessionId: parts[2]);
  }

  Future<void> _upsertCurrentDevice(AuthSession session) async {
    final devices = await fetchDeviceSessions(session: session);
    final current = AuthDeviceSession(
      id: session.tokens.sessionId,
      deviceName: 'Codex Dev Shell',
      platformLabel: 'Windows',
      lastActiveAt: DateTime.now(),
      isCurrent: true,
    );
    final others = devices
        .where((device) => device.id != current.id)
        .map(
          (device) => AuthDeviceSession(
            id: device.id,
            deviceName: device.deviceName,
            platformLabel: device.platformLabel,
            lastActiveAt: device.lastActiveAt,
            isCurrent: false,
          ),
        )
        .toList(growable: false);
    await _writeDevices(session.user.username, <AuthDeviceSession>[
      current,
      ...others,
    ]);
  }

  List<AuthDeviceSession> _defaultDevices({required String currentSessionId}) {
    return <AuthDeviceSession>[
      AuthDeviceSession(
        id: currentSessionId,
        deviceName: 'Codex Dev Shell',
        platformLabel: 'Windows',
        lastActiveAt: DateTime.now(),
        isCurrent: true,
      ),
      AuthDeviceSession(
        id: 'tablet-reviewer',
        deviceName: 'Product Review Tablet',
        platformLabel: 'Android',
        lastActiveAt: DateTime.now().subtract(const Duration(hours: 6)),
        isCurrent: false,
      ),
    ];
  }

  Future<void> _writeDevices(
    String username,
    List<AuthDeviceSession> devices,
  ) async {
    await _store.writeString(
      _deviceKey(username),
      jsonEncode(devices.map(_deviceToMap).toList(growable: false)),
    );
  }

  String _deviceKey(String username) => '$_deviceStorePrefix.$username';

  Map<String, dynamic> _userToMap(AppUser user) {
    return <String, dynamic>{
      'id': user.id,
      'username': user.username,
      'displayName': user.displayName,
      'role': user.role.name,
      'uid': user.uid,
      'level': user.level,
      'bio': user.bio,
      'avatarSeed': user.avatarSeed,
      'email': user.email,
      'provider': user.provider.name,
    };
  }

  AppUser _userFromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      username: map['username'] as String,
      displayName: map['displayName'] as String,
      role: AppUserRole.values.byName(map['role'] as String),
      uid: map['uid'] as String,
      level: map['level'] as int,
      bio: map['bio'] as String,
      avatarSeed: map['avatarSeed'] as int,
      email: map['email'] as String,
      provider: AuthProvider.values.byName(map['provider'] as String),
    );
  }

  Map<String, dynamic> _deviceToMap(AuthDeviceSession device) {
    return <String, dynamic>{
      'id': device.id,
      'deviceName': device.deviceName,
      'platformLabel': device.platformLabel,
      'lastActiveAt': device.lastActiveAt.toIso8601String(),
      'isCurrent': device.isCurrent,
    };
  }

  AuthDeviceSession _deviceFromMap(Map<String, dynamic> map) {
    return AuthDeviceSession(
      id: map['id'] as String,
      deviceName: map['deviceName'] as String,
      platformLabel: map['platformLabel'] as String,
      lastActiveAt: DateTime.parse(map['lastActiveAt'] as String),
      isCurrent: map['isCurrent'] as bool,
    );
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
      bio: '新加入的派对玩家',
      avatarSeed: uidTail % 8,
      email: '$username@ember.club',
      provider: AuthProvider.usernamePassword,
    );
  }
}

class _ParsedRefreshToken {
  const _ParsedRefreshToken({required this.username, required this.sessionId});

  final String username;
  final String sessionId;
}
