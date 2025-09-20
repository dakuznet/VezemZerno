import 'package:equatable/equatable.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}


// PROFILE
class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileSaving extends ProfileState {}

class ProfileSaved extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}


// CHANGE PROFILE IMAGE
class ProfileImageUploading extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileImageUploaded extends ProfileState {
  final String imageUrl;
  
  ProfileImageUploaded(this.imageUrl);
  
  @override
  List<Object> get props => [imageUrl];
}

class ProfileImageError extends ProfileState {
  final String message;
  
  ProfileImageError(this.message);
  
  @override
  List<Object> get props => [message];
}


// DELETE PROFILE
class AccountDeleting extends ProfileState {}

class AccountDeleted extends ProfileState {}

class AccountDeleteError extends ProfileState {
  final String message;

  AccountDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}

// CHANGE PASSWORD
class PasswordUpdating extends ProfileState {}
class PasswordUpdated extends ProfileState {}
class PasswordUpdateError extends ProfileState {
  final String message;

  PasswordUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}