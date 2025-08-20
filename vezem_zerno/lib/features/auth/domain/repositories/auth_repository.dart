import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendVerificationCode({
    required String phone,
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  });

  Future<Either<Failure, void>> verifyCode({
    required String phone,
    required String code,
  });

  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password
  });
}
