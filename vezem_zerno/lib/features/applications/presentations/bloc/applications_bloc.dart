import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/get_applications_by_status_usecase.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/get_user_responses_usecase.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

part 'applications_event.dart';
part 'applications_state.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final GetApplicationsByStatusUsecase getApplicationsByStatusUsecase;
  final GetUserResponsesUsecase getUserResponsesUsecase;

  ApplicationsBloc({
    required this.getApplicationsByStatusUsecase,
    required this.getUserResponsesUsecase,
  }) : super(ApplicationsInitial()) {
    on<LoadApplicationsEvent>(_onLoadApplications);
    on<LoadResponsesEvent>(_onLoadResponses);
  }

  Future<void> _onLoadApplications(
    LoadApplicationsEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading());

    final result = await getApplicationsByStatusUsecase.call(
      applicationStatus: event.applicationStatus,
    );

    result.fold(
      (failure) => emit(ApplicationsLoadingFailure()),
      (applications) => emit(ApplicationsLoaded(applications: applications)),
    );
  }

  Future<void> _onLoadResponses(
    LoadResponsesEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ResponsesLoading());

    final result = await getUserResponsesUsecase.call();

    result.fold(
      (failure) => emit(ResponsesLoadingFailure()),
      (applications) => emit(ResponsesLoaded(applications: applications)),
    );
  }
}
