// profile_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
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

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
    required this.uploadImageUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<SaveProfileEvent>(_onSaveProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(PasswordUpdating());

    final result = await changePasswordUseCase.call(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(
        PasswordUpdateError('Ошибка изменения пароля: ${failure.message}'),
      ),
      (_) {
        emit(PasswordUpdated());
      },
    );
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getProfileUseCase.call();
    result.fold(
      (failure) => emit(ProfileError('Ошибка загрузки профиля')),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onSaveProfile(
    SaveProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String? imageUrl;
      if (event.imageFile != null) {
        emit(ProfileImageUploading());
        final uploadResult = await uploadImageUseCase.call(
          event.imageFile!.path,
        );

        uploadResult.fold(
          (failure) => emit(ProfileError('Ошибка загрузки изображения')),
          (url) {
            emit(ProfileImageUploaded(url));
            imageUrl = url;
          },
        );
      }

      emit(ProfileSaving());

      final userEntity = UserEntity(
        id: event.userId,
        phone: event.phone,
        name: event.name,
        surname: event.surname,
        organization: event.organization,
        role: event.role,
        profileImage: imageUrl,
      );

      final updateResult = await updateProfileUseCase.call(userEntity);
      updateResult.fold(
        (failure) => emit(ProfileError('Ошибка сохранения профиля')),
        (_) {
          emit(ProfileSaved());
          add(LoadProfileEvent());
        },
      );
    } catch (e) {
      emit(ProfileError('Неизвестная ошибка'));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(AccountDeleting());
    final result = await deleteAccountUseCase.call();
    result.fold(
      (failure) => emit(AccountDeleteError('Ошибка удаления аккаунта')),
      (_) {
        emit(AccountDeleted());
      },
    );
  }
}
