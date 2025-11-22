import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

class GetApplicationsByStatusUsecase {
  final ApplicationsListRepository repository;

  GetApplicationsByStatusUsecase(this.repository);

  Future<Either<Failure, List<ApplicationEntity>>> call({
    required String applicationStatus,
    required int limit,
    ApplicationFilter? filter,
    required int offset,
  }) async {
    return repository.getApplicationsByStatus(
      applicationStatus: applicationStatus,
      limit: limit,
      offset: offset,
      filter: filter,
    );
  }
}
