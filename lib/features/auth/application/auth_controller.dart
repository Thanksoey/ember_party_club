import 'package:flutter/foundation.dart';

import '../data/dev_seed_auth_repository.dart';
import '../data/in_memory_auth_repository.dart';
import '../domain/app_user.dart';
import '../domain/auth_device_session.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';
import '../domain/auth_token_bundle.dart';

class AuthController extends ChangeNotifier {
  AuthController._(this._repository, this._session, this._deviceSessions);

  factory AuthController.test({AuthSession? session}) {
    final seededSession = session ??
        AuthSession(
          user: DevSeedAuthRepository.seededUsers[1],
          signedInAt: DateTime(2026, 3, 7, 12),
          tokens: AuthTokenBundle(
            accessToken: 'test-access',
            refreshToken: 'test-refresh',
            expiresAt: DateTime(2026, 3, 7, 20),
            sessionId: 'test-session',
          ),
        );
    return AuthController._(
      InMemoryAuthRepository(
        users: DevSeedAuthRepository.seededUsers,
        initialSession: seededSession,
      ),
      seededSession,
      const <AuthDeviceSession>[],
    );
  }

  factory AuthController.unauthenticatedTest() {
    return AuthController._(
      InMemoryAuthRepository(users: DevSeedAuthRepository.seededUsers),
      null,
      const <AuthDeviceSession>[],
    );
  }

  final AuthRepository _repository;
  AuthSession? _session;
  List<AuthDeviceSession> _deviceSessions;
  bool _isSubmitting = false;
  bool _isUpdatingProfile = false;
  bool _isSecurityBusy = false;
  AuthFailure? _loginError;
  AuthFailure? _securityError;

  AppUser? get currentUser => _session?.user;
  AuthSession? get currentSession => _session;
  bool get isAuthenticated => _session != null;
  bool get isSubmitting => _isSubmitting;
  bool get isUpdatingProfile => _isUpdatingProfile;
  bool get isSecurityBusy => _isSecurityBusy;
  bool get canAccessAdmin => currentUser?.isAdmin ?? false;
  AuthFailure? get loginError => _loginError;
  AuthFailure? get securityError => _securityError;
  List<AuthDeviceSession> get deviceSessions =>
      List<AuthDeviceSession>.unmodifiable(_deviceSessions);

  static Future<AuthController> bootstrap(AuthRepository repository) async {
    final session = await repository.restoreSession();
    final devices = session == null
        ? const <AuthDeviceSession>[]
        : await repository.fetchDeviceSessions();
    return AuthController._(repository, session, devices);
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _loginError = null;
    _isSubmitting = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 420));
    final response = await _repository.login(
      username: username,
      password: password,
    );

    _isSubmitting = false;
    if (!response.isSuccess) {
      _loginError = response.failure;
      notifyListeners();
      return false;
    }

    _session = response.session;
    _deviceSessions = await _repository.fetchDeviceSessions();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _session = null;
    _loginError = null;
    _securityError = null;
    _deviceSessions = const <AuthDeviceSession>[];
    await _repository.logout();
    notifyListeners();
  }

  Future<void> refreshSecuritySnapshot() async {
    if (!isAuthenticated) {
      return;
    }
    _isSecurityBusy = true;
    _securityError = null;
    notifyListeners();
    try {
      _deviceSessions = await _repository.fetchDeviceSessions();
    } on StateError {
      _securityError = AuthFailure.unauthorized;
    } finally {
      _isSecurityBusy = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String displayName,
    required String bio,
    required int avatarSeed,
  }) async {
    _isUpdatingProfile = true;
    notifyListeners();
    try {
      final updated = await _repository.updateProfile(
        displayName: displayName,
        bio: bio,
        avatarSeed: avatarSeed,
      );
      _session = _session?.copyWith(user: updated);
      return true;
    } finally {
      _isUpdatingProfile = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String nextPassword,
  }) async {
    _isSecurityBusy = true;
    _securityError = null;
    notifyListeners();
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        nextPassword: nextPassword,
      );
      return true;
    } on StateError catch (error) {
      _securityError = _failureFromCode(error.message);
      return false;
    } finally {
      _isSecurityBusy = false;
      notifyListeners();
    }
  }

  Future<void> signOutDevice(String deviceSessionId) async {
    _isSecurityBusy = true;
    _securityError = null;
    notifyListeners();
    try {
      await _repository.signOutDevice(deviceSessionId);
      _deviceSessions = await _repository.fetchDeviceSessions();
    } on StateError catch (error) {
      _securityError = _failureFromCode(error.message);
    } finally {
      _isSecurityBusy = false;
      notifyListeners();
    }
  }

  AuthFailure _failureFromCode(String? code) {
    for (final value in AuthFailure.values) {
      if (value.name == code) {
        return value;
      }
    }
    return AuthFailure.unauthorized;
  }
}
