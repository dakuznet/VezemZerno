part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class VerificationCodeSent extends AuthState {}

final class VerificationCodeSuccess extends AuthState {}

final class LoginSuccess extends AuthState {
  final UserEntity user;

  LoginSuccess(this.user);
}

class AuthUserAlreadyExists extends AuthState {
  final String message;

  AuthUserAlreadyExists(this.message);

  List<Object> get props => [message];
}

final class SessionRestored extends AuthState {
  final UserEntity user;

  SessionRestored(this.user);
}

class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated(this.user);
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

final class Unauthenticated extends AuthState {}

final class NoInternetConnection extends AuthState {
  final String message;

  NoInternetConnection(this.message);
}

final class PasswordResetLoading extends AuthState {}

final class PasswordResetCodeSent extends AuthState {}

final class PasswordResetSuccess extends AuthState {}

final class PasswordResetFailure extends AuthState {}
