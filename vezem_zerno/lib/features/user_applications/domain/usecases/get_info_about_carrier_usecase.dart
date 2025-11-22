import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class GetInfoAboutCarrierUsecase {
  final UserApplicationsRepository repository;

  GetInfoAboutCarrierUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call({required String userId}) async {
    return repository.getInfoAboutCarrier(userId: userId);
  }
}
