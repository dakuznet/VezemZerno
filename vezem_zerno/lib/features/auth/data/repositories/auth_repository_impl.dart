import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> sendVerificationCode({
    required String phone,
  }) async {
    return remoteDataSource.sendVerificationCode(phone: phone);
  }

  @override
  Future<Either<Failure, void>> verifyCode({
    required String phone,
    required String code,
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  }) async {
    return remoteDataSource.verifyCode(
      phone: phone,
      code: code,
      name: name,
      surname: surname,
      organization: organization,
      role: role,
      password: password,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
  }) async {
    return remoteDataSource.login(phone, password);
  }

  @override
  Future<Either<Failure, bool>> restoreSession() async {
    return remoteDataSource.restoreSession();
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return remoteDataSource.logout();
  }

  @override
  Future<Either<Failure, void>> forceLogout() async {
    return remoteDataSource.forceLogout();
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String phone,
  }) async {
    return remoteDataSource.requestPasswordReset(phone: phone);
  }

  @override
  Future<Either<Failure, void>> confrimPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    return remoteDataSource.confirmPasswordReset(
      phone: phone,
      code: code,
      newPassword: newPassword,
    );
  }
}
