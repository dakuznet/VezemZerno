import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:vezem_zerno/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    return remoteDataSource.getProfile();
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserEntity user) async {
    return remoteDataSource.updateProfile(user);
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    return remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return remoteDataSource.deleteAccount();
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    return remoteDataSource.uploadImage(filePath);
  }
}
