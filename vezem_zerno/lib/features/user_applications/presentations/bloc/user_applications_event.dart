part of 'user_applications_bloc.dart';

@immutable
abstract class UserApplicationsEvent extends Equatable {
  const UserApplicationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserApplicationsEvent extends UserApplicationsEvent {
  final String status;
  final String userId;

  const LoadUserApplicationsEvent({required this.status, required this.userId});

  @override
  List<Object?> get props => [status];
}

final class CreateUserApplicaitonEvent extends UserApplicationsEvent {
  final String? comment;
  final bool? dumpTrucks;
  final bool? charter;
  final String loadingDate;
  final String loadingMethod;
  final String loadingRegion;
  final String loadingLocality;
  final String unloadingRegion;
  final String unloadingLocality;
  final String crop;
  final String tonnage;
  final String distance;
  final String scalesCapacity;
  final String price;
  final String downtime;
  final String shortage;
  final String paymentTerms;
  final String paymentMethod;
  final String status;
  final String userId;

  const CreateUserApplicaitonEvent({
    this.comment,
    this.charter,
    this.dumpTrucks,
    required this.loadingRegion,
    required this.loadingLocality,
    required this.unloadingRegion,
    required this.unloadingLocality,
    required this.loadingMethod,
    required this.loadingDate,
    required this.crop,
    required this.tonnage,
    required this.distance,
    required this.scalesCapacity,
    required this.price,
    required this.downtime,
    required this.shortage,
    required this.paymentTerms,
    required this.paymentMethod,
    required this.status,
    required this.userId,
  });
}

final class LoadApplicationResponsesEvent extends UserApplicationsEvent {
  final String applicationId;

  const LoadApplicationResponsesEvent({required this.applicationId});
}

final class AcceptResponseEvent extends UserApplicationsEvent {
  final String applicationId;
  final String carrierId;
  final String userId;

  const AcceptResponseEvent({
    required this.applicationId,
    required this.carrierId,
    required this.userId,
  });
}

class MarkApplicationCompletedEvent extends UserApplicationsEvent {
  final String applicationId;
  final String userId;

  const MarkApplicationCompletedEvent({
    required this.applicationId,
    required this.userId,
  });

  @override
  List<Object> get props => [applicationId];
}

class MarkApplicationDeliveredEvent extends UserApplicationsEvent {
  final String applicationId;
  final String userId;

  const MarkApplicationDeliveredEvent({
    required this.applicationId,
    required this.userId,
  });

  @override
  List<Object> get props => [applicationId];
}

class LoadCarrierInfoEvent extends UserApplicationsEvent {
  final String carrierId;

  const LoadCarrierInfoEvent({required this.carrierId});

  @override
  List<Object> get props => [carrierId];
}
