import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class GetUserApplicationsByStatusUsecase {
  final UserApplicationsRepository repository;

  GetUserApplicationsByStatusUsecase(this.repository);

  Future<Either<Failure, List<ApplicationEntity>>> call({
    required String applicationStatus,
    required String userId,
  }) async {
    return repository.getUserApplicationsByStatus(
      userId: userId,
      applicationStatus: applicationStatus,
    );
  }
}
