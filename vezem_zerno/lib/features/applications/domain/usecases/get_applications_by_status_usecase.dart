import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

class GetApplicationsByStatusUsecase {
  final ApplicationsListRepository repository;

  GetApplicationsByStatusUsecase(this.repository);

  Future<Either<Failure, List<ApplicationModel>>> call({
    required String applicationStatus,
  }) async {
    return repository.getApplicationsByStatus(applicationStatus: applicationStatus);
  }
}
