part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class VerificationCodeSent extends AuthState {}

//final class VerificationCodeResent extends AuthState {}

final class VerificationCodeSuccess extends AuthState {}

final class LoginSuccess extends AuthState {
  final UserEntity user;

  LoginSuccess(this.user);
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
