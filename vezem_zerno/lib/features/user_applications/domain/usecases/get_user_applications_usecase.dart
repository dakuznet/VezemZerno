import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class GetUserApplicationsByStatusUsecase {
  final UserApplicationsRepository repository;

  GetUserApplicationsByStatusUsecase(this.repository);

  Future<Either<Failure, List<ApplicationModel>>> call({
    required String applicationStatus,
  }) async {
    return repository.getUserApplicationsByStatus(
      applicationStatus: applicationStatus,
    );
  }
}
