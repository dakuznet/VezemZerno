import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/applications/data/datasources/applications_list_remote_data_source.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

class ApplicationsListRemoteDataSourceImpl
    extends ApplicationsListRemoteDataSource {
  final AppwriteService _appwriteService;

  ApplicationsListRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getApplicationsByStatus({
    required String applicationStatus,
    ApplicationFilter? filter,
  }) async {
    try {
      final applications = await _appwriteService
          .getApplicationsByStatusWithFilter(
            applicationStatus: applicationStatus,
            filter: filter,
          );

      return Right(applications.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Ошибка получения заявок по статусу: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getUserResponses({required String userId}) async {
    try {
      final responses = await _appwriteService.getUserResponses(userId: userId);

      return Right(responses.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Ошибка получения откликов пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> respondToApplication({
    required String applicationId,
    required String userId,
  }) async {
    try {
      await _appwriteService.respondToApplication(applicationId: applicationId, userId: userId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка отклика на заявку: $e'));
    }
  }
}
