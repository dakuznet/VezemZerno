import 'package:fpdart/fpdart.dart';
import 'dart:io' as io;
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AppwriteService _appwriteService;

  ProfileRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userModel = await _appwriteService.getCurrentUserDocument();
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure('Ошибка загрузки профиля: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserEntity user) async {
    try {
      await _appwriteService.updateUserProfile(
        name: user.name,
        surname: user.surname,
        organization: user.organization,
        role: user.role,
        phone: user.phone,
        profileImage: user.profileImage,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка обновления профиля: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await _appwriteService.changePassword(oldPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка изменения пароля: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _appwriteService.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Ошибка удаления аккаунта: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    try {
      final imageUrl = await _appwriteService.uploadProfileImage(
        io.File(filePath),
      );
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure('Ошибка загрузки изображения: $e'));
    }
  }
}
