part of 'applications_bloc.dart';

abstract class ApplicationsState extends Equatable {
  const ApplicationsState();

  @override
  List<Object?> get props => [];
}

final class ApplicationsInitial extends ApplicationsState {}

final class ApplicationsLoading extends ApplicationsState {
  final bool isFirstLoad;

  const ApplicationsLoading({this.isFirstLoad = true});
}

final class ApplicationsLoadingSuccess extends ApplicationsState {
  final List<ApplicationEntity> applications;
  final bool hasReachedMax;
  final int currentPage;
  final ApplicationFilter? filter;

  const ApplicationsLoadingSuccess({
    required this.applications,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.filter,
  });

  @override
  List<Object?> get props => [applications, hasReachedMax, currentPage, filter];
}

final class ApplicationsLoadingFailure extends ApplicationsState {}

final class ApplicationsLoadingMore extends ApplicationsState {
  final List<ApplicationEntity> applications;

  const ApplicationsLoadingMore({required this.applications});

  @override
  List<Object?> get props => [applications];
}

final class ResponsesLoading extends ApplicationsState {}

final class ResponsesLoadingSuccess extends ApplicationsState {
  final List<ApplicationEntity> applications;

  const ResponsesLoadingSuccess({required this.applications});

  @override
  List<Object?> get props => [applications];
}

final class ResponsesLoadingFailure extends ApplicationsState {}

final class RespondToApplicaitonLoading extends ApplicationsState {}

final class RespondToApplicaitonLoadingSuccess extends ApplicationsState {}

final class RespondToApplicaitonLoadingFailure extends ApplicationsState {}
