import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendVerificationCode({required String phone});

  Future<Either<Failure, void>> verifyCode({
    required String phone,
    required String code,
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  });

  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, bool>> restoreSession();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> forceLogout();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, void>> requestPasswordReset({required String phone});

  Future<Either<Failure, void>> confrimPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  });
}
