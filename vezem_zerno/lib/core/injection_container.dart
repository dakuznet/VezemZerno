import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/applications/data/datasources/applications_list_remote_data_source.dart';
import 'package:vezem_zerno/features/applications/data/datasources/applications_list_remote_data_source_impl.dart';
import 'package:vezem_zerno/features/applications/data/repositories/applications_list_repository_impl.dart';
import 'package:vezem_zerno/features/applications/domain/repositories/applications_list_repository.dart';
import 'package:vezem_zerno/features/applications/domain/usecases/get_applications_by_status_usecase.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vezem_zerno/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:vezem_zerno/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/force_logout_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/login_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/register_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/verify_code_usecase.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:vezem_zerno/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:vezem_zerno/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:vezem_zerno/features/profile/domain/repositories/profile_repository.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:vezem_zerno/features/profile/domain/usecases/upload_image_usecase.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/user_applications/data/datasources/user_applications_remote_data_source.dart';
import 'package:vezem_zerno/features/user_applications/data/datasources/user_applications_remote_data_source_impl.dart';
import 'package:vezem_zerno/features/user_applications/data/repositories/user_applications_repository_impl.dart';
import 'package:vezem_zerno/features/user_applications/domain/repositories/user_applications_repository.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/create_application_usecase.dart';
import 'package:vezem_zerno/features/user_applications/domain/usecases/get_user_applications_usecase.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';

final getIt = GetIt.instance;

void init() {
  // ===== SERVICES =====
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => InternetConnection());
  getIt.registerLazySingleton(() => AppwriteService());

  // ===== DATA SOURCES =====
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ApplicationsListRemoteDataSource>(
    () => ApplicationsListRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<UserApplicationsRemoteDataSource>(
    () => UserApplicationsRemoteDataSourceImpl(getIt()),
  );

  // ===== REPOSITORIES =====
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ApplicationsListRepository>(
    () => ApplicationsListRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<UserApplicationsRepository>(
    () => UserApplicationsRepositoryImpl(remoteDataSource: getIt()),
  );

  // ===== USE CASES =====
  // Auth
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyCodeUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => RestoreSessionUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUsecase(getIt()));
  getIt.registerLazySingleton(() => ForceLogoutUseCase(getIt()));

  // Profile
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(getIt()));
  getIt.registerLazySingleton(() => UploadImageUseCase(getIt()));

  // Applications
  getIt.registerLazySingleton(() => GetApplicationsByStatusUsecase(getIt()));

  // User applications
  getIt.registerLazySingleton(
    () => GetUserApplicationsByStatusUsecase(getIt()),
  );
  getIt.registerLazySingleton(() => CreateUserApplicationUsecase(getIt()));

  // ===== BLOC =====
  getIt.registerLazySingleton(
    () => AuthBloc(
      registerUseCase: getIt(),
      verifyCodeUseCase: getIt(),
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      forceLogoutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      restoreSessionUseCase: getIt(),
      connectionChecker: getIt(),
      connectivity: getIt(),
    ),
  );

  getIt.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: getIt(),
      updateProfileUseCase: getIt(),
      changePasswordUseCase: getIt(),
      deleteAccountUseCase: getIt(),
      uploadImageUseCase: getIt(),
      connectionChecker: getIt(),
      connectivity: getIt(),
    ),
  );

  getIt.registerFactory(
    () => ApplicationsBloc(getApplicationsByStatusUsecase: getIt()),
  );

  getIt.registerFactory(
    () => UserApplicationsBloc(
      getUserApplicationsByStatusUsecase: getIt(),
      createUserApplicationUsecase: getIt(),
    ),
  );
}
