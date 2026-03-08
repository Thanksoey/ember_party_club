import 'app_user.dart';
import 'auth_device_session.dart';
import 'auth_response.dart';
import 'auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AuthResponse> login({
    required String username,
    required String password,
  });

  Future<AuthResponse> register({
    required String username,
    required String password,
    required String displayName,
  });

  Future<void> logout();

  Future<AppUser> updateProfile({
    required String displayName,
    required String bio,
    required int avatarSeed,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String nextPassword,
  });

  Future<List<AuthDeviceSession>> fetchDeviceSessions();

  Future<void> signOutDevice(String deviceSessionId);
}
