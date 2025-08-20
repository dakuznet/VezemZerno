import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/login_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/register_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/verify_code_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final VerifyCodeUseCase verifyCodeUseCase;
  final LoginUseCase loginUseCase;
  final AppwriteService appwriteService;
  AuthBloc({
    required this.registerUseCase,
    required this.verifyCodeUseCase,
    required this.loginUseCase,
    required this.appwriteService,
  }) : super(AuthInitial()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCode);
    on<VerifyCodeEvent>(_onVerifyCode);
    on<LoginEvent>(_onLogin);
    //on<ResendCodeEvent>(_onResendCode);
    on<RestoreSessionEvent>(_onRestoreSession);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRestoreSession(
    RestoreSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isValid = await appwriteService.restoreSession();
      if (isValid) {
        try {
          final user = await appwriteService.account.get();
          final phone = user.email.split('@')[0];
          final userData = await appwriteService.getUserByPhone(phone);
          emit(
            SessionRestored(
              UserEntity(
                id: user.$id,
                phone: phone,
                name: userData['name'],
                surname: userData['surname'],
                organization: userData['organization'],
                role: userData['role'],
              ),
            ),
          );
        } catch (e) {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await appwriteService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure('Ошибка выхода: $e'));
    }
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase.call(
      phone: event.phone,
      name: event.name,
      surname: event.surname,
      organization: event.organization,
      role: event.role,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(VerificationCodeSent()),
    );
  }

  Future<void> _onVerifyCode(
    VerifyCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyCodeUseCase.call(
      phone: event.phone,
      code: event.code,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(VerificationCodeSuccess()),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase.call(
      phone: event.phone,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }

  // Future<void> _onResendCode(
  //   ResendCodeEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   final result = await registerUseCase.call(
  //     phone: event.phone,
  //     name: '',
  //     surname: '',
  //     organization: '',
  //     role: '',
  //     password: event.password,
  //   );

  //   result.fold(
  //     (failure) => emit(AuthFailure(failure.message)),
  //     (_) => emit(VerificationCodeResent()),
  //   );
  // }
}
