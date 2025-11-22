import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';

class RespondToApplicationUsecase {
  final ApplicationsListRepository repository;

  RespondToApplicationUsecase(this.repository);

  Future<Either<Failure, void>> call({required String applicationId, required String userId}) async {
    return repository.respondToApplication(applicationId: applicationId, userId: userId);
  }
}
