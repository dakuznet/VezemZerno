part of 'user_applications_bloc.dart';

@immutable
abstract class UserApplicationsState extends Equatable {
  const UserApplicationsState();

  @override
  List<Object?> get props => [];
}

class UserApplicationsInitial extends UserApplicationsState {}

class UserApplicationsLoading extends UserApplicationsState {
  final String status;

  const UserApplicationsLoading({required this.status});

  @override
  List<Object?> get props => [status];
}

class UserApplicationsLoadSuccess extends UserApplicationsState {
  final String status;
  final List<ApplicationEntity> applications;

  const UserApplicationsLoadSuccess({
    required this.status,
    required this.applications,
  });

  @override
  List<Object?> get props => [status, applications];
}

class UserApplicationsLoadFailure extends UserApplicationsState {
  final String status;
  final String error;

  const UserApplicationsLoadFailure({
    required this.status,
    required this.error,
  });

  @override
  List<Object?> get props => [status, error];
}

final class UserApplicationCreating extends UserApplicationsState {}

final class UserApplicationCreatingSuccess extends UserApplicationsState {}

final class UserApplicationCreatingFailure extends UserApplicationsState {}

final class UserApplicationResponsesLoading extends UserApplicationsState {}

final class UserApplicationResponsesLoadingSuccess
    extends UserApplicationsState {
  final List<UserEntity> users;

  const UserApplicationResponsesLoadingSuccess({required this.users});

  @override
  List<Object?> get props => [users];
}

final class UserApplicationResponsesLoadingFailure
    extends UserApplicationsState {}

final class ResponseAccepting extends UserApplicationsState {}

final class ResponseAcceptingSuccess extends UserApplicationsState {}

final class ResponseAcceptingFailure extends UserApplicationsState {}

final class ApplicationMarkingComlepeted extends UserApplicationsState {}

final class ApplicationMarkingComlepetedSuccess extends UserApplicationsState {}

final class ApplicationMarkingComlepetedFailure extends UserApplicationsState {
  final String error;

  const ApplicationMarkingComlepetedFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class ApplicationMarkingDelivered extends UserApplicationsState {}

final class ApplicationMarkingDeliveredSuccess extends UserApplicationsState {}

final class ApplicationMarkingDeliveredFailure extends UserApplicationsState {
  final String error;

  const ApplicationMarkingDeliveredFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class LoadingCarrierInfo extends UserApplicationsState {}

final class LoadingCarrierInfoSuccess extends UserApplicationsState {
  final UserEntity carrier;

  const LoadingCarrierInfoSuccess({required this.carrier});

  @override
  List<Object?> get props => [carrier];
}

class LoadingCarrierInfoFailure extends UserApplicationsState {
  final String error;

  const LoadingCarrierInfoFailure({required this.error});

  @override
  List<Object> get props => [error];
}
