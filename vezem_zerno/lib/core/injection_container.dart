import 'package:get_it/get_it.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vezem_zerno/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:vezem_zerno/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vezem_zerno/features/auth/domain/repositories/auth_repository.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/login_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/register_usecase.dart';
import 'package:vezem_zerno/features/auth/domain/usecases/verify_code_usecase.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

void init() {
  // Bloc
  getIt.registerFactory(
    () => AuthBloc(
      registerUseCase: getIt(),
      verifyCodeUseCase: getIt(),
      loginUseCase: getIt(),
      appwriteService: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyCodeUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  // Appwrite service
  getIt.registerLazySingleton(() => AppwriteService());
}
