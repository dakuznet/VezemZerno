import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
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

  Future<Either<Failure, UserModel>> login(String phone, String password);

  Future<Either<Failure, bool>> restoreSession();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> forceLogout();

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
