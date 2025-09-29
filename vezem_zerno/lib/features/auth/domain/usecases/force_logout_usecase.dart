import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class ForceLogoutUseCase {
  final AuthRepository repository;

  ForceLogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return repository.forceLogout();
  }
}