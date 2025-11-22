import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

abstract class ApplicationsListRemoteDataSource {
  Future<Either<Failure, List<ApplicationEntity>>> getApplicationsByStatus({
    required String applicationStatus,
    required int limit,
    required int offset,
    ApplicationFilter? filter
  });

  Future<Either<Failure, List<ApplicationEntity>>> getUserResponses({required String userId});

  Future<Either<Failure, void>> respondToApplication({required String applicationId, required String userId});
}
