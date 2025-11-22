import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';

abstract class UserApplicationsRemoteDataSource {
  Future<Either<Failure, List<ApplicationEntity>>> getUserApplicationsByStatus({
    required String applicationStatus,
    required String userId,
  });

  Future<Either<Failure, ApplicationEntity>> createApplication({
    String? comment,
    bool? charter,
    bool? dumpTrucks,
    required String loadingRegion,
    required String loadingLocality,
    required String unloadingRegion,
    required String unloadingLocality,
    required String loadingMethod,
    required String loadingDate,
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
    required String userId,
  });

  Future<Either<Failure, List<UserEntity>>> getApplicationResponses({
    required String applicationId,
  });

  Future<Either<Failure, void>> acceptResponse({
    required String carrierId,
    required String applicationId,
  });

  Future<Either<Failure, void>> markApplicationCompleted({
    required String applicationId,
  });

  Future<Either<Failure, void>> markApplicationDelivered({
    required String applicationId,
  });

  Future<Either<Failure, UserEntity>> getInfoAboutCarrier({
    required String userId,
  });
}
