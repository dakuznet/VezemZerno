import 'package:fpdart/fpdart.dart';
import 'package:vezem_zerno/core/error/failures.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/user_applications/data/datasources/user_applications_remote_data_source.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

class UserApplicationsRemoteDataSourceImpl
    extends UserApplicationsRemoteDataSource {
  final AppwriteService _appwriteService;

  UserApplicationsRemoteDataSourceImpl(this._appwriteService);

  @override
  Future<Either<Failure, List<ApplicationModel>>> getUserApplicationsByStatus({
    required String applicationStatus,
  }) async {
    try {
      final applications = await _appwriteService.getUserApplicationsByStatus(
        applicationStatus: applicationStatus,
      );

      return Right(applications);
    } catch (e) {
      return Left(
        ServerFailure('Ошибка получения заявок пользователя по статусу: $e'),
      );
    }
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
    try {
      final applicationFromDB = await _appwriteService.createApplication(
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

      return Right(applicationFromDB);
    } catch (e) {
      return Left(ServerFailure('Ошибка создания заявки: $e'));
    }
  }
}
