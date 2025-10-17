part of 'user_applications_bloc.dart';

abstract class UserApplicationsState extends Equatable {
  const UserApplicationsState();

  @override
  List<Object?> get props => [];
}

final class UserApplicationsInitial extends UserApplicationsState {}

final class UserApplicationsLoading extends UserApplicationsState {}

final class UserApplicationsLoaded extends UserApplicationsState {
  final List<ApplicationModel> applications;

  const UserApplicationsLoaded({required this.applications});

  @override
  List<Object?> get props => [applications];
}

final class UserApplicationsLoadingFailure extends UserApplicationsState {}

final class UserApplicationCreating extends UserApplicationsState {}

final class UserApplicationCreated extends UserApplicationsState {}

final class UserApplicationCreatingFailure extends UserApplicationsState {}
