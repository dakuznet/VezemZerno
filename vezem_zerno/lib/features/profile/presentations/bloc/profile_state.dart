import 'package:equatable/equatable.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

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