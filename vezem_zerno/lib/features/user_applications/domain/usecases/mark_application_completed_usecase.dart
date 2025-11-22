import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class MarkApplicationCompletedUsecase {
  final UserApplicationsRepository repository;

  MarkApplicationCompletedUsecase(this.repository);

  Future<Either<Failure, void>> call({required String applicationId}) async {
    return repository.markApplicationCompleted(applicationId: applicationId);
  }
}
