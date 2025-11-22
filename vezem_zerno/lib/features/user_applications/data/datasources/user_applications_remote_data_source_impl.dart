import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/user_applications/data/datasources/user_applications_remote_data_source.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';

class UserApplicationsRemoteDataSourceImpl
    extends UserApplicationsRemoteDataSource {
  final AppwriteService _appwriteService;

  UserApplicationsRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<Either<Failure, List<ApplicationEntity>>> getUserApplicationsByStatus({
    required String applicationStatus,
    required String userId,
  }) async {
    try {
      final applications = await _appwriteService.getUserApplicationsByStatus(
        applicationStatus: applicationStatus,
        userId: userId,
      );

      return Right(applications.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationEntity>> createApplication({
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
    required String userId,
  }) async {
    try {
      final applicationFromDB = await _appwriteService.createApplication(
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

      return Right(applicationFromDB.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getApplicationResponses({
    required String applicationId,
  }) async {
    try {
      final users = await _appwriteService.getApplicationResponses(
        applicationId: applicationId,
      );

      return Right(users.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptResponse({
    required String carrierId,
    required String applicationId,
  }) async {
    try {
      await _appwriteService.acceptResponse(
        carrierId: carrierId,
        applicationId: applicationId,
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markApplicationCompleted({
    required String applicationId,
  }) async {
    try {
      await _appwriteService.markApplicationCompleted(
        applicationId: applicationId,
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markApplicationDelivered({
    required String applicationId,
  }) async {
    try {
      await _appwriteService.markApplicationDelivered(
        applicationId: applicationId,
      );

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getInfoAboutCarrier({
    required String userId,
  }) async {
    try {
      final carrier = await _appwriteService.getUserById(userId: userId);

      return Right(carrier.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
