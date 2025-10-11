// profile_bloc.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart'
    hide CheckInternetConnection, NoInternetConnection;
import 'package:vezem_zerno/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/upload_image_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final AuthBloc authBloc;
  final Connectivity _connectivity;
  final InternetConnection _connectionChecker;
  StreamSubscription? _connectivitySubscription;
  bool _isInternetAvailable = true;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
    required this.authBloc,
    required this.uploadImageUseCase,
    required Connectivity connectivity,
    required InternetConnection connectionChecker,
  }) : _connectivity = connectivity,
       _connectionChecker = connectionChecker,
       super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<SaveProfileEvent>(_onSaveProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<CheckInternetConnection>(_onCheckInternetConnection);

    _initializeInternetMonitoring();
  }

  Future<void> _initializeInternetMonitoring() async {
    // Первоначальная проверка интернета
    await _checkInternetAndUpdateState();

    // Запускаем мониторинг изменений подключения
    _startMonitoring();
  }

  Future<void> _checkInternetAndUpdateState() async {
    final hasConnection = await _checkInternetAccess();
    if (hasConnection != _isInternetAvailable) {
      _isInternetAvailable = hasConnection;
      if (!hasConnection) {
        add(CheckInternetConnection());
      } else if (state is NoInternetConnection) {
        // Автоматически загружаем профиль при восстановлении интернета
        add(LoadProfileEvent());
      }
    }
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
      await _checkInternetAndUpdateState();
    });
  }

  Future<void> _onCheckInternetConnection(
    CheckInternetConnection event,
    Emitter<ProfileState> emit,
  ) async {
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
    }
  }

  Future<void> _executeWithInternetCheck(
    Future<void> Function() action, {
    required Emitter<ProfileState> emit,
    String? loadingState,
  }) async {
    // Автоматически проверяем интернет перед выполнением любого действия
    final hasConnection = await _checkInternetAccess();
    if (!hasConnection) {
      emit(NoInternetConnection('Нет интернет-соединения'));
      return;
    }

    if (loadingState != null) {
      // Используем динамическое создание состояния загрузки
      switch (loadingState) {
        case 'ProfileLoading':
          emit(ProfileLoading());
          break;
        case 'ProfileSaving':
          emit(ProfileSaving());
          break;
        case 'PasswordUpdating':
          emit(PasswordUpdating());
          break;
        case 'AccountDeleting':
          emit(AccountDeleting());
          break;
      }
    }

    await action();
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _executeWithInternetCheck(
      () async {
        final result = await changePasswordUseCase.call(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
        );

        result.fold(
          (failure) => emit(
            PasswordUpdateError('Ошибка изменения пароля: ${failure.message}'),
          ),
          (_) => emit(PasswordUpdated()),
        );
      },
      emit: emit,
      loadingState: 'PasswordUpdating',
    );
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _executeWithInternetCheck(
      () async {
        final result = await getProfileUseCase.call();
        result.fold(
          (failure) =>
              emit(ProfileError('Ошибка загрузки профиля: ${failure.message}')),
          (user) => emit(ProfileLoaded(user)),
        );
      },
      emit: emit,
      loadingState: 'ProfileLoading',
    );
  }

  Future<void> _onSaveProfile(
    SaveProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _executeWithInternetCheck(
      () async {
        try {
          String? imageUrl;
          if (event.imageFile != null) {
            final uploadResult = await uploadImageUseCase.call(
              event.imageFile!.path,
            );

            uploadResult.fold(
              (failure) => emit(
                ProfileError('Ошибка загрузки изображения: ${failure.message}'),
              ),
              (url) => imageUrl = url,
            );

            if (imageUrl == null) return;
          }

          final userEntity = UserEntity(
            id: '',
            phone: event.phone,
            name: event.name,
            surname: event.surname,
            organization: event.organization,
            role: event.role,
            profileImage: imageUrl,
          );

          final updateResult = await updateProfileUseCase.call(userEntity);
          updateResult.fold(
            (failure) => emit(
              ProfileError('Ошибка сохранения профиля: ${failure.message}'),
            ),
            (_) {
              emit(ProfileSaved());
              add(LoadProfileEvent());
            },
          );
        } catch (e) {
          emit(ProfileError('Неизвестная ошибка: $e'));
        }
      },
      emit: emit,
      loadingState: 'ProfileSaving',
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _executeWithInternetCheck(
      () async {
        final result = await deleteAccountUseCase.call();
        result.fold(
          (failure) => emit(
            AccountDeleteError('Ошибка удаления аккаунта: ${failure.message}'),
          ),
          (_) {
            emit(AccountDeleted());
            authBloc.add(AuthLogoutEvent());
          },
        );
      },
      emit: emit,
      loadingState: 'AccountDeleting',
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
