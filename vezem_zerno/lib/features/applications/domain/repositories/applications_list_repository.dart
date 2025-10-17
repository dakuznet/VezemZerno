import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

abstract class ApplicationsListRepository {
  Future<Either<Failure, List<ApplicationModel>>> getApplicationsByStatus({required String applicationStatus});
}