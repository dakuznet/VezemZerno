import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/globals.dart';
import 'package:vezem_zerno/core/injection_container.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  init();

  final authBloc = getIt<AuthBloc>();
  final profileBloc = getIt<ProfileBloc>();
  final applicationsBloc = getIt<ApplicationsBloc>();
  final userApplicationsBloc = getIt<UserApplicationsBloc>();

  runApp(
    MyApp(
      authBloc: authBloc,
      profileBloc: profileBloc,
      applicationsBloc: applicationsBloc,
      userApplicationsBloc: userApplicationsBloc,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ProfileBloc profileBloc;
  final ApplicationsBloc applicationsBloc;
  final UserApplicationsBloc userApplicationsBloc;

  const MyApp({
    super.key,
    required this.authBloc,
    required this.profileBloc,
    required this.applicationsBloc,
    required this.userApplicationsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authBloc),
            BlocProvider.value(value: profileBloc),
            BlocProvider.value(value: applicationsBloc),
            BlocProvider.value(value: userApplicationsBloc),
          ],
          child: MaterialApp.router(
            scaffoldMessengerKey: AppGlobals.scaffoldMessengerKey,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter(authBloc: authBloc).config(),
            debugShowCheckedModeBanner: false,
            supportedLocales: const [Locale('ru', 'RU')],
          ),
        );
      },
      useInheritedMediaQuery: true,
      ensureScreenSize: true,
    );
  }
}
