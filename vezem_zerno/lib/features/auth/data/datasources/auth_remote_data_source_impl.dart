import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/auth/data/models/user_model.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppwriteService _appwriteService;

  AuthRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<Either<Failure, void>> sendVerificationCode({
    required String phone,
  }) async {
    try {
      final data = await _appwriteService.sendVerificationCode(phone: phone);

      if (data['success'] == true) {
        return const Right(null);
      } else {
        if (data['error'] == 'USER_ALREADY_EXISTS') {
          return Left(UserAlreadyExistsFailure());
        } else {
          return Left(ServerFailure(data['error'] ?? 'Ошибка отправки SMS'));
        }
      }
    } on AppwriteException catch (e) {
      if (e.message?.contains('USER_ALREADY_EXISTS') == true) {
        return Left(UserAlreadyExistsFailure());
      }
      return Left(ServerFailure('Ошибка отправки SMS: ${e.message}'));
    } catch (e) {
      if (e.toString().contains('USER_ALREADY_EXISTS')) {
        return Left(UserAlreadyExistsFailure());
      }
      return Left(ServerFailure('Ошибка отправки SMS: $e'));
    }
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
    try {
      final data = await _appwriteService.verifyCode(
        phone: phone,
        code: code,
        name: name,
        surname: surname,
        organization: organization,
        role: role,
        password: password,
      );

      if (data['success'] == true) {
        return Right(null);
      } else {
        return Left(ServerFailure(data['error'] ?? 'Ошибка верификации'));
      }
    } catch (e) {
      return Left(ServerFailure('Ошибка подтверждения кода: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login(
    String phone,
    String password,
  ) async {
    try {
      final session = await _appwriteService.createSession(phone, password);

      final userData = await _appwriteService.getUserByPhone(phone);

      return Right(
        UserModel(
          id: session.userId,
          phone: phone,
          name: userData['name'],
          surname: userData['surname'],
          organization: userData['organization'],
          role: userData['role'],
        ),
      );
    } on AppwriteException catch (e) {
      return Left(
        ServerFailure(
          e.code == 401
              ? 'Неверный номер или пароль'
              : 'Ошибка входа: ${e.message}',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Неизвестная ошибка: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> restoreSession() async {
    try {
      final isValid = await _appwriteService.restoreSession();
      return Right(isValid);
    } catch (e) {
      return Left(ServerFailure('Ошибка восстановления сессии: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _appwriteService.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка выхода: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forceLogout() async {
    try {
      await _appwriteService.forceLogout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка принудительного выхода: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await _appwriteService.account.get();
      final phone = user.email.split('@')[0];
      final userData = await _appwriteService.getUserByPhone(phone);

      final userEntity = UserEntity(
        id: user.$id,
        phone: phone,
        name: userData['name'] ?? '',
        surname: userData['surname'] ?? '',
        organization: userData['organization'] ?? '',
        role: userData['role'] ?? '',
      );

      return Right(userEntity);
    } catch (e) {
      return Left(ServerFailure('Ошибка получения пользователя: $e'));
    }
  }
}
