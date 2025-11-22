import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/get_applications_by_status_usecase.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/get_user_responses_usecase.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/respond_to_application_usecase.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

part 'applications_event.dart';
part 'applications_state.dart';

class ApplicationsBloc extends Bloc<ApplicationsEvent, ApplicationsState> {
  final GetApplicationsByStatusUsecase getApplicationsByStatusUsecase;
  final GetUserResponsesUsecase getUserResponsesUsecase;
  final RespondToApplicationUsecase respondToApplicationUsecase;

  ApplicationFilter? _currentFilter;
  int _applicationsPage = 1;
  final int _pageSize = 20;

  ApplicationsBloc({
    required this.getApplicationsByStatusUsecase,
    required this.getUserResponsesUsecase,
    required this.respondToApplicationUsecase,
  }) : super(ApplicationsInitial()) {
    on<LoadApplicationsEvent>(_onLoadApplications);
    on<LoadResponsesEvent>(_onLoadResponses);
    on<LoadMoreApplicationsEvent>(_onLoadMoreApplications);
    on<RespondToApplicaitonEvent>(_onRespondToApplication);
  }

  Future<void> _onLoadApplications(
    LoadApplicationsEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ApplicationsLoading(isFirstLoad: true));
    _applicationsPage = 1;
    _currentFilter = event.filter;

    final result = await getApplicationsByStatusUsecase.call(
      applicationStatus: event.applicationStatus,
      limit: _pageSize,
      offset: 0,
      filter: _currentFilter,
    );

    result.fold(
      (failure) => emit(ApplicationsLoadingFailure()),
      (applications) => emit(
        ApplicationsLoadingSuccess(
          applications: applications,
          currentPage: _applicationsPage,
          hasReachedMax: applications.length < _pageSize,
          filter: _currentFilter,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreApplications(
    LoadMoreApplicationsEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    if (state is ApplicationsLoadingSuccess) {
      final currentState = state as ApplicationsLoadingSuccess;
      if (currentState.hasReachedMax) return;

      emit(ApplicationsLoadingMore(applications: currentState.applications));

      _applicationsPage++;
      final result = await getApplicationsByStatusUsecase.call(
        applicationStatus: event.applicationStatus,
        limit: _pageSize,
        offset: (_applicationsPage - 1) * _pageSize,
        filter: _currentFilter,
      );

      result.fold(
        (failure) {
          _applicationsPage--;
          emit(ApplicationsLoadingFailure());
        },
        (newApplications) {
          final allApplications = [
            ...currentState.applications,
            ...newApplications,
          ];
          emit(
            ApplicationsLoadingSuccess(
              applications: allApplications,
              currentPage: _applicationsPage,
              hasReachedMax: newApplications.length < _pageSize,
              filter: _currentFilter,
            ),
          );
        },
      );
    }
  }

  Future<void> _onLoadResponses(
    LoadResponsesEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(ResponsesLoading());

    final result = await getUserResponsesUsecase.call(userId: event.userId);

    result.fold(
      (failure) => emit(ResponsesLoadingFailure()),
      (applications) =>
          emit(ResponsesLoadingSuccess(applications: applications)),
    );
  }

  Future<void> _onRespondToApplication(
    RespondToApplicaitonEvent event,
    Emitter<ApplicationsState> emit,
  ) async {
    emit(RespondToApplicaitonLoading());

    final result = await respondToApplicationUsecase.call(
      applicationId: event.applicationId,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(RespondToApplicaitonLoadingFailure()),
      (_) { emit(RespondToApplicaitonLoadingSuccess()); add(LoadApplicationsEvent(applicationStatus: 'active'));},
    );
  }
}
