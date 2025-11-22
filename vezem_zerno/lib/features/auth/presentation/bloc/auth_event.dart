part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SendVerificationCodeEvent extends AuthEvent {
  final String phone;

  SendVerificationCodeEvent({required this.phone});
}

final class VerifyCodeEvent extends AuthEvent {
  final String phone;
  final String code;
  final String name;
  final String surname;
  final String organization;
  final String role;
  final String password;

  VerifyCodeEvent({
    required this.name,
    required this.surname,
    required this.organization,
    required this.role,
    required this.password,
    required this.phone,
    required this.code,
  });
}

final class LoginEvent extends AuthEvent {
  final String phone;
  final String password;

  LoginEvent({required this.phone, required this.password});
}

final class RestoreSessionEvent extends AuthEvent {}

final class AuthLogoutEvent extends AuthEvent {}

final class CheckInternetConnection extends AuthEvent {}

final class RequestPasswordResetEvent extends AuthEvent {
  final String phone;
  RequestPasswordResetEvent({required this.phone});
}

final class ConfirmPasswordResetEvent extends AuthEvent {
  final String phone;
  final String code;
  final String newPassword;
  ConfirmPasswordResetEvent({
    required this.phone,
    required this.code,
    required this.newPassword,
  });
}
