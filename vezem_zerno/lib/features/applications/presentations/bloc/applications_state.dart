part of 'applications_bloc.dart';

abstract class ApplicationsState extends Equatable {
  const ApplicationsState();

  @override
  List<Object?> get props => [];
}

final class ApplicationsInitial extends ApplicationsState {}

final class ApplicationsLoading extends ApplicationsState {}

final class ApplicationsLoaded extends ApplicationsState {
  final List<ApplicationModel> applications;

  const ApplicationsLoaded({required this.applications});

  @override
  List<Object?> get props => [applications];
}

final class ApplicationsLoadingFailure extends ApplicationsState {}

final class ResponsesLoading extends ApplicationsState {}

final class ResponsesLoaded extends ApplicationsState {
  final List<ApplicationModel> applications;

  const ResponsesLoaded({required this.applications});

  @override
  List<Object?> get props => [applications];
}

final class ResponsesLoadingFailure extends ApplicationsState {}
