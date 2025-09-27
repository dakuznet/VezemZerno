import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

    Future<Either<Failure, UserEntity>> call() async {
    return repository.getCurrentUser();
  }
}