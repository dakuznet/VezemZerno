import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordResetUsecase {
  final AuthRepository repository;

  RequestPasswordResetUsecase(this.repository);

  Future<Either<Failure, void>> call({required String phone}) async {
    return repository.requestPasswordReset(phone: phone);
  }
}
