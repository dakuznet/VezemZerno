import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class RestoreSessionUseCase {
  final AuthRepository repository;

  RestoreSessionUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    return repository.restoreSession();
  }
}