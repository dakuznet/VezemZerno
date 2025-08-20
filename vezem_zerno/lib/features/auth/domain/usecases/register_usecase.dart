import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String phone,
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  }) async {
    return repository.sendVerificationCode(
      phone: phone,
      name: name,
      surname: surname,
      organization: organization,
      role: role,
      password: password,
    );
  }
}