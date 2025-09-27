import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/profile/domain/repositories/profile_repository.dart';

class UploadImageUseCase {
  final ProfileRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) async {
    return repository.uploadImage(filePath);
  }
}
