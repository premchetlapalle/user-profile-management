// authentication_event.dart
abstract class AuthEvent {}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  AuthSignUp(this.email, this.password);
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;
  AuthSignIn(this.email, this.password);
}

class AuthCheckLoggedIn extends AuthEvent {}

class AuthLogout extends AuthEvent {}
