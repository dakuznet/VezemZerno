import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/data/datasources/user_applications_remote_data_source.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class UserApplicationsRepositoryImpl extends UserApplicationsRepository {
  final UserApplicationsRemoteDataSource remoteDataSource;

  UserApplicationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getUserApplicationsByStatus({
    required String applicationStatus,
    required String userId,
  }) async {
    return remoteDataSource.getUserApplicationsByStatus(
      applicationStatus: applicationStatus,
      userId: userId,
    );
  }

  @override
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
  }) async {
    return remoteDataSource.createApplication(
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

  @override
  Future<Either<Failure, List<UserEntity>>> getApplicationRespones({
    required String applicationId,
  }) async {
    return remoteDataSource.getApplicationResponses(
      applicationId: applicationId,
    );
  }

  @override
  Future<Either<Failure, void>> acceptResponse({
    required String carrierId,
    required String applicationId,
  }) async {
    return remoteDataSource.acceptResponse(
      carrierId: carrierId,
      applicationId: applicationId,
    );
  }

  @override
  Future<Either<Failure, void>> markApplicationCompleted({
    required String applicationId,
  }) async {
    return remoteDataSource.markApplicationCompleted(
      applicationId: applicationId,
    );
  }

  @override
  Future<Either<Failure, void>> markApplicationDelivered({
    required String applicationId,
  }) async {
    return remoteDataSource.markApplicationDelivered(
      applicationId: applicationId,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> getInfoAboutCarrier({
    required String userId,
  }) async {
    return remoteDataSource.getInfoAboutCarrier(userId: userId);
  }
}
