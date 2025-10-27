import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/applications/data/datasources/applications_list_remote_data_source.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

class ApplicationsListRemoteDataSourceImpl
    extends ApplicationsListRemoteDataSource {
  final AppwriteService _appwriteService;

  ApplicationsListRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByStatus({
    required String applicationStatus,
  }) async {
    try {
      final applications = await _appwriteService.getApplicationsByStatus(
        applicationStatus: applicationStatus,
      );

      return Right(applications);
    } catch (e) {
      return Left(ServerFailure('Ошибка получения заявок по статусу: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationModel>>> getUserResponses() async {
    try {
      final responses = await _appwriteService.getUserResponses();

      return Right(responses);
    } catch (e) {
      return Left(ServerFailure('Ошибка получения откликов пользователя: $e'));
    }
  }
}
