import '../domain/app_user.dart';
import '../domain/auth_device_session.dart';
import '../domain/auth_response.dart';
import '../domain/auth_session.dart';

abstract class AuthApi {
  Future<AuthResponse> login({
    required String username,
    required String password,
  });

  Future<AuthResponse> register({
    required String username,
    required String password,
    required String displayName,
  });

  Future<AuthResponse> refreshSession({required String refreshToken});

  Future<void> logout({required AuthSession session});

  Future<AppUser> updateProfile({
    required AuthSession session,
    required String displayName,
    required String bio,
    required int avatarSeed,
  });

  Future<void> changePassword({
    required AuthSession session,
    required String currentPassword,
    required String nextPassword,
  });

  Future<List<AuthDeviceSession>> fetchDeviceSessions({
    required AuthSession session,
  });

  Future<void> signOutDevice({
    required AuthSession session,
    required String deviceSessionId,
  });
}
