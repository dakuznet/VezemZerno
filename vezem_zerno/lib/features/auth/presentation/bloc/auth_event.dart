part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SendVerificationCodeEvent extends AuthEvent {
  final String phone;
  final String name;
  final String surname;
  final String organization;
  final String role;
  final String password;

  SendVerificationCodeEvent({
    required this.phone,
    required this.name,
    required this.surname,
    required this.organization,
    required this.role,
    required this.password,
  });
}

final class VerifyCodeEvent extends AuthEvent {
  final String phone;
  final String code;

  VerifyCodeEvent({required this.phone, required this.code});
}

final class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  LoginEvent({
    required this.phone,
    required this.password,
  });
}

final class ResendCodeEvent extends AuthEvent {
  final String phone;
  final String password;

  ResendCodeEvent({required this.phone, required this.password});
}

final class RestoreSessionEvent extends AuthEvent {}

final class LogoutEvent extends AuthEvent {}
