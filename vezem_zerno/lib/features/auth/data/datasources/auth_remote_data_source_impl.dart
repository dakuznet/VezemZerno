import 'package:appwrite/appwrite.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
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
  Future<Either<Failure, UserEntity>> login(
    String phone,
    String password,
  ) async {
    try {
      await _appwriteService.createSession(phone, password);

      final user = await _appwriteService.getUserByPhone(phone);

      return Right(user.toEntity());
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
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final currentUser = await _appwriteService.getCurrentUserDocument();

      return Right(currentUser.toEntity());
    } catch (e) {
      return Left(ServerFailure('Ошибка получения пользователя: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String phone,
  }) async {
    try {
      await _appwriteService.requestPasswordReset(phone: phone);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirmPasswordReset({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _appwriteService.confirmPasswordReset(
        phone: phone,
        code: code,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
