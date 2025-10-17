import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/create_application_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/get_user_applications_usecase.dart';

part 'user_applications_event.dart';
part 'user_applications_state.dart';

class UserApplicationsBloc
    extends Bloc<UserApplicationsEvent, UserApplicationsState> {
  final GetUserApplicationsByStatusUsecase getUserApplicationsByStatusUsecase;
  final CreateUserApplicationUsecase createUserApplicationUsecase;
  UserApplicationsBloc({
    required this.getUserApplicationsByStatusUsecase,
    required this.createUserApplicationUsecase,
  }) : super(UserApplicationsInitial()) {
    on<LoadUserApplicationsEvent>(_onLoadUserApplications);
    on<CreateUserApplicaitonEvent>(_onCreateUserApplication);
  }

  FutureOr<void> _onLoadUserApplications(
    LoadUserApplicationsEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(UserApplicationsLoading());

    final result = await getUserApplicationsByStatusUsecase.call(
      applicationStatus: event.applicationStatus,
    );

    result.fold(
      (failure) => emit(UserApplicationsLoadingFailure()),
      (applications) =>
          emit(UserApplicationsLoaded(applications: applications)),
    );
  }

  FutureOr<void> _onCreateUserApplication(
    CreateUserApplicaitonEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(UserApplicationCreating());

    final result = await createUserApplicationUsecase.call(
      loadingPlace: event.loadingPlace,
      loadingMethod: event.loadingMethod,
      loadingDate: event.loadingDate,
      unloadingPlace: event.unloadingPlace,
      crop: event.crop,
      tonnage: event.tonnage,
      distance: event.distance,
      scalesCapacity: event.scalesCapacity,
      price: event.price,
      downtime: event.downtime,
      shortage: event.shortage,
      paymentTerms: event.paymentTerms,
      paymentMethod: event.paymentMethod,
      status: event.status,
      comment: event.comment,
      charter: event.charter,
      dumpTrucks: event.dumpTrucks,
    );

    result.fold(
      (failure) => emit(UserApplicationCreatingFailure()),
      (applicaiton) => emit(UserApplicationCreated()),
    );
  }
}
