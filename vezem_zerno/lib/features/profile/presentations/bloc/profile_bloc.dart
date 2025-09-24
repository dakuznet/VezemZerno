import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AppwriteService appwriteService;

  ProfileBloc(this.appwriteService) : super(ProfileInitial()) {
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
    try {
      await appwriteService.changePassword(
        event.oldPassword,
        event.newPassword,
      );
      emit(PasswordUpdated());
    } catch (e) {
      emit(PasswordUpdateError('Ошибка изменения пароля: $e'));
    }
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await appwriteService.getCurrentUser();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Ошибка загрузки профиля'));
    }
  }

  Future<void> _onSaveProfile(
    SaveProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSaving());
    try {
      String? imageUrl;

      if (event.imageFile != null) {
        imageUrl = await appwriteService.uploadProfileImage(event.imageFile!);
      }

      await appwriteService.updateUserProfile(
        name: event.name,
        surname: event.surname,
        organization: event.organization,
        role: event.role,
        phone: event.phone,
        profileImage: imageUrl,
      );

      emit(ProfileSaved());
      add(LoadProfileEvent());
    } catch (e) {
      emit(ProfileError('Ошибка сохранения профиля: $e'));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(AccountDeleting());
    try {
      await appwriteService.deleteUser();
      emit(AccountDeleted());
    } catch (e) {
      emit(AccountDeleteError('Ошибка удаления аккаунта: $e'));
    }
  }
}
