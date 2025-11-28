import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/applications/data/datasources/applications_list_remote_data_source.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

class ApplicationsListRepositoryImpl extends ApplicationsListRepository {
  final ApplicationsListRemoteDataSource remoteDataSource;

  ApplicationsListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getApplicationsByStatus({
    required String applicationStatus,
    ApplicationFilter? filter,
  }) async {
    return remoteDataSource.getApplicationsByStatus(
      applicationStatus: applicationStatus,
      filter: filter,
    );
  }

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getUserResponses({required String userId}) async {
    return remoteDataSource.getUserResponses(userId: userId);
  }

  @override
  Future<Either<Failure, void>> respondToApplication({
    required String applicationId,
    required String userId,
  }) {
    return remoteDataSource.respondToApplication(applicationId: applicationId, userId: userId);
  }
}
