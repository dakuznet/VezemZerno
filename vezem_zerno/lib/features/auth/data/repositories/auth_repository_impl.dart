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
    required String name,
    required String surname,
    required String organization,
    required String role,
    required String password,
  }) async {
    return remoteDataSource.sendVerificationCode(
      phone: phone,
      name: name,
      surname: surname,
      organization: organization,
      role: role,
      password: password,
    );
  }

  @override
  Future<Either<Failure, void>> verifyCode({
    required String phone,
    required String code,
  }) async {
    return remoteDataSource.verifyCode(phone: phone, code: code);
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password
  }) async {
    return remoteDataSource.login(phone, password);
  }
}
