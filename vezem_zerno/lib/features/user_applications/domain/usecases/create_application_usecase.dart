import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class CreateUserApplicationUsecase {
  final UserApplicationsRepository repository;

  CreateUserApplicationUsecase(this.repository);

  Future<Either<Failure, ApplicationEntity>> call({
    String? comment,
    bool? charter,
    bool? dumpTrucks,
    required String loadingMethod,
    required String loadingDate,
        required String loadingRegion,
    required String loadingLocality,
    required String unloadingRegion,
    required String unloadingLocality,
    required String crop,
    required String tonnage,
    required String distance,
    required String scalesCapacity,
    required String price,
    required String downtime,
    required String shortage,
    required String paymentTerms,
    required String paymentMethod,
    required String status,
    required String userId
  }) async {
    return repository.createApplication(
      loadingRegion: loadingRegion,
      loadingLocality: loadingLocality,
      loadingMethod: loadingMethod,
      loadingDate: loadingDate,
      unloadingRegion: unloadingRegion,
      unloadingLocality: unloadingLocality,
      crop: crop,
      tonnage: tonnage,
      distance: distance,
      scalesCapacity: scalesCapacity,
      price: price,
      downtime: downtime,
      shortage: shortage,
      paymentTerms: paymentTerms,
      paymentMethod: paymentMethod,
      status: status,
      comment: comment,
      charter: charter,
      dumpTrucks: dumpTrucks,
      userId: userId
    );
  }
}
