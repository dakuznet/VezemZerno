import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/get_applications_by_status_usecase.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

part 'applications_event.dart';
part 'applications_state.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final GetApplicationsByStatusUsecase getApplicationsByStatusUsecase;

  ApplicationsBloc({required this.getApplicationsByStatusUsecase})
    : super(ApplicationsInitial()) {
    on<LoadApplicationsEvent>(_onLoadApplications);
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
}
