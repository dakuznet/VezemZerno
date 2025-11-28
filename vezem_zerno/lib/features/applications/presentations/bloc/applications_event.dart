part of 'applications_bloc.dart';

@immutable
sealed class ApplicationsEvent {}

final class LoadApplicationsEvent extends ApplicationsEvent {
  final String applicationStatus;
  final ApplicationFilter? filter;

  LoadApplicationsEvent({
    required this.applicationStatus, this.filter,
  });
}

final class LoadMoreApplicationsEvent extends ApplicationsEvent {
  final String applicationStatus;
  final ApplicationFilter? filter;

  LoadMoreApplicationsEvent({required this.applicationStatus, this.filter});
}

final class LoadResponsesEvent extends ApplicationsEvent {
  final String userId;

  LoadResponsesEvent({required this.userId});
}

final class RespondToApplicaitonEvent extends ApplicationsEvent {
  final String applicationId;
  final String userId;

  RespondToApplicaitonEvent({required this.applicationId, required this.userId});
}
