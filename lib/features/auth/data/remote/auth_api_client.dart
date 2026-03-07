import '../../domain/auth_failure.dart';
import 'auth_api_models.dart';

class AuthApiException implements Exception {
  const AuthApiException(this.failure);

  final AuthFailure failure;
}

abstract class AuthApiClient {
  Future<AuthApiSessionPayload> login({
    required String username,
    required String password,
  });

  Future<AuthApiSessionPayload> refreshSession({
    required String refreshToken,
    required String sessionId,
  });

  Future<AuthApiSessionPayload> updateProfile({
    required String accessToken,
    required AuthApiProfileUpdatePayload payload,
  });

  Future<void> changePassword({
    required String accessToken,
    required AuthApiChangePasswordPayload payload,
  });

  Future<AuthApiDeviceListPayload> fetchDevices({
    required String accessToken,
  });

  Future<void> revokeDevice({
    required String accessToken,
    required String deviceSessionId,
  });
}
