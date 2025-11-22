import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';

class GetUserResponsesUsecase {
  final ApplicationsListRepository repository;

  GetUserResponsesUsecase(this.repository);

  Future<Either<Failure, List<ApplicationEntity>>> call({required String userId}) async {
    return repository.getUserResponses(userId: userId);
  }
}
