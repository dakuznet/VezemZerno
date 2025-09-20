import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/injection_container.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
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

  authBloc.add(RestoreSessionEvent());

  runApp(MyApp(authBloc: authBloc, profileBloc: profileBloc));
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  final ProfileBloc profileBloc;

  const MyApp({super.key, required this.authBloc, required this.profileBloc});

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
          ],
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is NoInternetConnection) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 14.sp,
                        color: ColorsConstants.primaryBrownColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor:
                        ColorsConstants.primaryTextFormFieldBackgorundColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0.r).r,
                      side: BorderSide(color: Colors.green, width: 2.0.w),
                    ),
                  ),
                );
              }
            },
            child: MaterialApp.router(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routerConfig: AppRouter(authBloc: authBloc).config(),
              debugShowCheckedModeBanner: false,
              supportedLocales: const [Locale('ru', 'RU')],
            ),
          ),
        );
      },
    );
  }
}
