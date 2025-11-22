import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/login_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/register_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/verify_code_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final VerifyCodeUseCase verifyCodeUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RestoreSessionUseCase restoreSessionUseCase;
  final GetCurrentUserUsecase getCurrentUserUseCase;
  final RequestPasswordResetUsecase requestPasswordResetUsecase;
  final ConfirmPasswordResetUsecase confirmPasswordResetUsecase;
  final Connectivity _connectivity;
  final InternetConnection _connectionChecker;
  StreamSubscription? _connectivitySubscription;
  bool _hasAttemptedRestore = false;

  AuthBloc({
    required this.confirmPasswordResetUsecase,
    required this.requestPasswordResetUsecase,
    required this.registerUseCase,
    required this.verifyCodeUseCase,
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.restoreSessionUseCase,
    required Connectivity connectivity,
    required InternetConnection connectionChecker,
  }) : _connectivity = connectivity,
       _connectionChecker = connectionChecker,
       super(AuthInitial()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCode);
    on<VerifyCodeEvent>(_onVerifyCode);
    on<LoginEvent>(_onLogin);
    on<RestoreSessionEvent>(_onRestoreSession);
    on<AuthLogoutEvent>(_onLogout);
    on<CheckInternetConnection>(_onCheckInternetConnection);
    on<RequestPasswordResetEvent>(_onRequestPasswordReset);
    on<ConfirmPasswordResetEvent>(_onConfirmPasswordReset);

    _startMonitoring();
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final hasConnection = await _connectionChecker.hasInternetAccess;

      final isConnected =
          connectivityResult.isNotEmpty &&
          !connectivityResult.contains(ConnectivityResult.none);

      return isConnected && hasConnection;
    } catch (e) {
      return false;
    }
  }

  void _startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) async {
      final hasConnection = await _checkInternetAccess();

      if (hasConnection &&
          _hasAttemptedRestore &&
          state is NoInternetConnection) {
        add(RestoreSessionEvent());
      } else if (!hasConnection) {
        add(CheckInternetConnection());
      }
    });
  }

  Future<void> _onCheckInternetConnection(
    CheckInternetConnection event,
    Emitter<AuthState> emit,
  ) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
    }
  }

  Future<void> _onRestoreSession(
    RestoreSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    _hasAttemptedRestore = true;
    emit(AuthLoading());

    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

    try {
      final restoreResult = await restoreSessionUseCase.call();

      await restoreResult.fold(
        (failure) async {
          if (_isNetworkRelatedError(failure)) {
            emit(NoInternetConnection('Ошибка сети: ${failure.message}'));
          } else {
            emit(Unauthenticated());
          }
        },
        (isValid) async {
          if (!isValid) {
            emit(Unauthenticated());
            return;
          }

          final userResult = await getCurrentUserUseCase.call();

          userResult.fold(
            (failure) => emit(Unauthenticated()),
            (userEntity) => emit(LoginSuccess(userEntity)),
          );
        },
      );
    } catch (e) {
      if (_isNetworkException(e)) {
        emit(NoInternetConnection('Ошибка соединения: $e'));
      } else {
        emit(Unauthenticated());
      }
    }
  }

  bool _isNetworkRelatedError(Failure failure) {
    final message = failure.message.toLowerCase();
    return message.contains('network') ||
        message.contains('connection') ||
        message.contains('интернет') ||
        message.contains('сеть') ||
        message.contains('timeout') ||
        message.contains('connect');
  }

  bool _isNetworkException(dynamic e) {
    final message = e.toString().toLowerCase();
    return message.contains('socket') ||
        message.contains('network') ||
        message.contains('connection') ||
        message.contains('connect') ||
        message.contains('timed out') ||
        message.contains('интернет') ||
        message.contains('сеть');
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase.call();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onRequestPasswordReset(
    RequestPasswordResetEvent event,
    Emitter<AuthState> emit,
  ) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

    emit(PasswordResetLoading());

    final result = await requestPasswordResetUsecase.call(phone: event.phone);

    result.fold(
      (failure) => emit(PasswordResetFailure()),
      (_) => emit(PasswordResetCodeSent()),
    );
  }

  Future<void> _onConfirmPasswordReset(
    ConfirmPasswordResetEvent event,
    Emitter<AuthState> emit,
  ) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

    emit(PasswordResetLoading());

    final result = await confirmPasswordResetUsecase.call(
      phone: event.phone,
      code: event.code,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(PasswordResetFailure()),
      (_) => emit(PasswordResetSuccess()),
    );
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

    emit(AuthLoading());
    final result = await registerUseCase.call(phone: event.phone);

    result.fold((failure) {
      if (failure is UserAlreadyExistsFailure) {
        emit(AuthUserAlreadyExists(failure.message));
      } else {
        emit(AuthFailure(failure.message));
      }
    }, (_) => emit(VerificationCodeSent()));
  }

  Future<void> _onVerifyCode(
    VerifyCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

    emit(AuthLoading());

    final result = await verifyCodeUseCase.call(
      phone: event.phone,
      code: event.code,
      name: event.name,
      surname: event.surname,
      organization: event.organization,
      role: event.role,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(VerificationCodeSuccess()),
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

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

  @override
  Future<void> close() {
    _hasAttemptedRestore = false;
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
