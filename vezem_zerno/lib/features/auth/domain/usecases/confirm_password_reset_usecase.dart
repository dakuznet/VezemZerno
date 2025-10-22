import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class ConfirmPasswordResetUsecase {
  final AuthRepository repository;

  ConfirmPasswordResetUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    return repository.confrimPasswordReset(
      phone: phone,
      code: code,
      newPassword: newPassword,
    );
  }
}
