import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, void>> updateProfile(UserEntity user);
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, String>> uploadImage(String filePath);
}
