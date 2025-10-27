part of 'applications_bloc.dart';

@immutable
sealed class ApplicationsEvent {}

final class LoadApplicationsEvent extends ApplicationsEvent {
  final String applicationStatus;

  LoadApplicationsEvent({required this.applicationStatus});
}

final class LoadResponsesEvent extends ApplicationsEvent {}
