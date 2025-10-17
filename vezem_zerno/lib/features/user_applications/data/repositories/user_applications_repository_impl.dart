import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/features/user_applications/data/datasources/user_applications_remote_data_source.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';

class UserApplicationsRepositoryImpl extends UserApplicationsRepository {
  final UserApplicationsRemoteDataSource remoteDataSource;

  UserApplicationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ApplicationModel>>> getUserApplicationsByStatus({
    required String applicationStatus,
  }) async {
    return remoteDataSource.getUserApplicationsByStatus(
      applicationStatus: applicationStatus,
    );
  }

  @override
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
  }) async {
    return remoteDataSource.createApplication(
      loadingPlace: loadingPlace,
      loadingMethod: loadingMethod,
      loadingDate: loadingDate,
      unloadingPlace: unloadingPlace,
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
    );
  }
}
