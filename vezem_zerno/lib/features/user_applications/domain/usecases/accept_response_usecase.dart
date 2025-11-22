import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class AcceptResponseUsecase {
  final UserApplicationsRepository repository;

  AcceptResponseUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String carrierId,
    required String applicationId,
  }) async {
    return repository.acceptResponse(
      carrierId: carrierId,
      applicationId: applicationId,
    );
  }
}
