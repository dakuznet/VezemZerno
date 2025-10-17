part of 'user_applications_bloc.dart';

sealed class UserApplicationsEvent {}

final class LoadUserApplicationsEvent extends UserApplicationsEvent {
  final String applicationStatus;

  LoadUserApplicationsEvent({required this.applicationStatus});
}

final class CreateUserApplicaitonEvent extends UserApplicationsEvent {
  String? comment;
  bool? dumpTrucks;
  bool? charter;
  final String loadingPlace;
  final String loadingDate;
  final String loadingMethod;
  final String unloadingPlace;
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

  CreateUserApplicaitonEvent({
    this.comment,
    this.charter,
    this.dumpTrucks,
    required this.loadingPlace,
    required this.loadingMethod,
    required this.loadingDate,
    required this.unloadingPlace,
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
  });
}
