import 'package:equatable/equatable.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// Initial and Loading States
class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

// Profile Saving States
class ProfileSaving extends ProfileState {}

class ProfileSaved extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

// Profile Image States
class ProfileImageUploading extends ProfileState {}

class ProfileImageUploaded extends ProfileState {
  final String imageUrl;

  const ProfileImageUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ProfileImageError extends ProfileState {
  final String message;

  const ProfileImageError(this.message);

  @override
  List<Object> get props => [message];
}

// Account Deletion States
class AccountDeleting extends ProfileState {}

class AccountDeleted extends ProfileState {}

class AccountDeleteError extends ProfileState {
  final String message;

  const AccountDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}

// Password Update States
class PasswordUpdating extends ProfileState {}

class PasswordUpdated extends ProfileState {}

class PasswordUpdateError extends ProfileState {
  final String message;

  const PasswordUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

// Internet Connection State
class NoInternetConnection extends ProfileState {
  final String message;

  const NoInternetConnection(this.message);

  @override
  List<Object?> get props => [message];
}
