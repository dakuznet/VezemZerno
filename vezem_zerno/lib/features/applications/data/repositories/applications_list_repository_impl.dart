import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/applications/data/datasources/applications_list_remote_data_source.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

class ApplicationsListRepositoryImpl extends ApplicationsListRepository {
  final ApplicationsListRemoteDataSource remoteDataSource;

  ApplicationsListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByStatus({
    required String applicationStatus,
  }) async {
    return remoteDataSource.getApplicationsByStatus(
      applicationStatus: applicationStatus,
    );
  }

  @override
  Future<Either<Failure, List<ApplicationModel>>> getUserResponses() async {
    return remoteDataSource.getUserResponses();
  }
}
