import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

abstract class UserApplicationsRemoteDataSource {
  Future<Either<Failure, List<ApplicationModel>>> getUserApplicationsByStatus({
    required String applicationStatus,
  });

  Future<Either<Failure, ApplicationModel>> createApplication({
    String? comment,
    bool? charter,
    bool? dumpTrucks,
    required String loadingPlace,
    required String loadingMethod,
    required String loadingDate,
    required String unloadingPlace,
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
  });
}
