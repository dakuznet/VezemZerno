import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class GetApplicationResponesUsecase {
  final UserApplicationsRepository repository;

  GetApplicationResponesUsecase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call({
    required String applicationId
  }) async {
    return repository.getApplicationRespones(applicationId: applicationId);
  }
}