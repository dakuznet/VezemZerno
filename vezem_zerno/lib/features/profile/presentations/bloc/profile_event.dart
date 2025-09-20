import 'dart:io' as io;

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class SaveProfileEvent extends ProfileEvent {
  final String name;
  final String surname;
  final String organization;
  final String role;
  final String phone;
  final io.File? imageFile;

  SaveProfileEvent({
    required this.name,
    required this.surname,
    required this.organization,
    required this.role,
    required this.phone,
    this.imageFile,
  });

  @override
  List<Object?> get props => [name, surname, organization, role, phone];
}

class ProfileImageSelectedEvent extends ProfileEvent {
  final io.File imageFile;

  ProfileImageSelectedEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class UploadProfileImageEvent extends ProfileEvent {
  final io.File imageFile;

  UploadProfileImageEvent(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class DeleteAccountEvent extends ProfileEvent {}