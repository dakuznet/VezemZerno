import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/accept_response_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/create_application_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/get_application_respones_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/get_info_about_carrier_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/get_user_applications_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/mark_application_completed_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/mark_application_delivered_usecase.dart';

part 'user_applications_event.dart';
part 'user_applications_state.dart';

class UserApplicationsBloc
    extends Bloc<UserApplicationsEvent, UserApplicationsState> {
  final GetUserApplicationsByStatusUsecase getUserApplicationsByStatusUsecase;
  final CreateUserApplicationUsecase createUserApplicationUsecase;
  final GetApplicationResponesUsecase getApplicationResponesUsecase;
  final AcceptResponseUsecase acceptResponseUsecase;
  final MarkApplicationCompletedUsecase markApplicationCompletedUsecase;
  final GetInfoAboutCarrierUsecase getInfoAboutCarrierUsecase;
  final MarkApplicationDeliveredUsecase markApplicationDeliveredUsecase;
  UserApplicationsBloc({
    required this.getApplicationResponesUsecase,
    required this.getUserApplicationsByStatusUsecase,
    required this.createUserApplicationUsecase,
    required this.acceptResponseUsecase,
    required this.markApplicationCompletedUsecase,
    required this.getInfoAboutCarrierUsecase,
    required this.markApplicationDeliveredUsecase,
  }) : super(UserApplicationsInitial()) {
    on<LoadUserApplicationsEvent>(_onLoadUserApplications);
    on<CreateUserApplicaitonEvent>(_onCreateUserApplication);
    on<LoadApplicationResponsesEvent>(_onLoadApplicationResponses);
    on<AcceptResponseEvent>(_onAcceptResponse);
    on<MarkApplicationCompletedEvent>(_onMarkApplicationCompleted);
    on<LoadCarrierInfoEvent>(_onLoadCarrierInfo);
    on<MarkApplicationDeliveredEvent>(_onMarkApplicationDelivered);
  }

  Future<void> _onLoadUserApplications(
    LoadUserApplicationsEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(UserApplicationsLoading(status: event.status));

    final result = await getUserApplicationsByStatusUsecase.call(
      userId: event.userId,
      applicationStatus: event.status,
    );

    result.fold(
      (failure) => emit(
        UserApplicationsLoadFailure(
          status: event.status,
          error:
              'Произошла ошибка при попытке загрузки пользовательских заявок',
        ),
      ),
      (applications) => emit(
        UserApplicationsLoadSuccess(
          status: event.status,
          applications: applications,
        ),
      ),
    );
  }

  Future<void> _onCreateUserApplication(
    CreateUserApplicaitonEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(UserApplicationCreating());

    final result = await createUserApplicationUsecase.call(
      userId: event.userId,
      loadingRegion: event.loadingRegion,
      loadingLocality: event.loadingLocality,
      loadingMethod: event.loadingMethod,
      loadingDate: event.loadingDate,
      unloadingRegion: event.unloadingRegion,
      unloadingLocality: event.unloadingLocality,
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
      (applicaiton)  { emit(UserApplicationCreatingSuccess()); add(LoadUserApplicationsEvent(status: 'active', userId: event.userId));},
    );
  }

  Future<void> _onMarkApplicationCompleted(
    MarkApplicationCompletedEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(ApplicationMarkingComlepeted());

    final result = await markApplicationCompletedUsecase.call(
      applicationId: event.applicationId,
    );

    result.fold(
      (failure) => emit(
        ApplicationMarkingComlepetedFailure(
          error: 'Произошла ошибка при попытке завершить заявку',
        ),
      ),
      (_) { emit(ApplicationMarkingComlepetedSuccess()); add(LoadUserApplicationsEvent(status: 'processing', userId: event.userId));},
    );
  }

  Future<void> _onMarkApplicationDelivered(
    MarkApplicationDeliveredEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(ApplicationMarkingDelivered());

    final result = await markApplicationDeliveredUsecase.call(
      applicationId: event.applicationId,
    );

    result.fold(
      (failure) => emit(
        ApplicationMarkingDeliveredFailure(
          error: 'Произошла ошибка при попытке отметить заявку доставленной',
        ),
      ),
      (_) => emit(ApplicationMarkingDeliveredSuccess()),
    );
  }

  Future<void> _onLoadApplicationResponses(
    LoadApplicationResponsesEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(UserApplicationResponsesLoading());

    final result = await getApplicationResponesUsecase.call(
      applicationId: event.applicationId,
    );

    result.fold(
      (failure) => emit(UserApplicationResponsesLoadingFailure()),
      (users) => emit(UserApplicationResponsesLoadingSuccess(users: users)),
    );
  }

  Future<void> _onAcceptResponse(
    AcceptResponseEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(ResponseAccepting());

    final result = await acceptResponseUsecase.call(
      carrierId: event.carrierId,
      applicationId: event.applicationId,
    );

    result.fold(
      (failure) => emit(ResponseAcceptingFailure()),
      (_) { emit(ResponseAcceptingSuccess()); add(LoadUserApplicationsEvent(status: 'active', userId: event.userId));},
    );
  }

  Future<void> _onLoadCarrierInfo(
    LoadCarrierInfoEvent event,
    Emitter<UserApplicationsState> emit,
  ) async {
    emit(LoadingCarrierInfo());

    final result = await getInfoAboutCarrierUsecase.call(
      userId: event.carrierId,
    );

    result.fold(
      (failure) => emit(
        LoadingCarrierInfoFailure(
          error: 'Ошибка загрузки информации о перевозчике',
        ),
      ),
      (carrier) => emit(LoadingCarrierInfoSuccess(carrier: carrier)),
    );
  }
}
