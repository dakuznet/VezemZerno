part of 'applications_bloc.dart';

@immutable
sealed class ApplicationsEvent {}

final class LoadApplicationsEvent extends ApplicationsEvent {
  final String applicationStatus;
  final int limit;
  final ApplicationFilter? filter;
  final int offset;

  LoadApplicationsEvent({
    required this.applicationStatus,
    this.limit = 20,
    this.filter,
    this.offset = 0,
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
