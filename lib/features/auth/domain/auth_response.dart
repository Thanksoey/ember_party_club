import 'auth_failure.dart';
import 'auth_session.dart';

class AuthResponse {
  const AuthResponse._({this.session, this.failure});

  const AuthResponse.success(AuthSession session) : this._(session: session);

  const AuthResponse.failure(AuthFailure failure) : this._(failure: failure);

  final AuthSession? session;
  final AuthFailure? failure;

  bool get isSuccess => session != null;
}
