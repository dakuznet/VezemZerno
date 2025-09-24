import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/login_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/register_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/verify_code_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final VerifyCodeUseCase verifyCodeUseCase;
  final LoginUseCase loginUseCase;
  final AppwriteService appwriteService;
  final Connectivity _connectivity;
  final InternetConnection _connectionChecker;
  StreamSubscription? _connectivitySubscription;

  AuthBloc({
    required this.registerUseCase,
    required this.verifyCodeUseCase,
    required this.loginUseCase,
    required this.appwriteService,
    required Connectivity connectivity,
    required InternetConnection connectionChecker,
  }) : _connectivity = connectivity,
       _connectionChecker = connectionChecker,
       super(AuthInitial()) {
    on<SendVerificationCodeEvent>(_onSendVerificationCode);
    on<VerifyCodeEvent>(_onVerifyCode);
    on<LoginEvent>(_onLogin);
    on<RestoreSessionEvent>(_onRestoreSession);
    on<LogoutEvent>(_onLogout);
    on<CheckInternetConnection>(_onCheckInternetConnection);

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
      if (!hasConnection) {
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
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

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
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }
    emit(AuthLoading());
    final result = await registerUseCase.call(
      phone: event.phone,
      name: event.name,
      surname: event.surname,
      organization: event.organization,
      role: event.role,
      password: event.password,
    );

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
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
