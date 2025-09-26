import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/splash_screen.dart';
import 'package:vezem_zerno/features/application_screen/presentations/screens/application_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/login_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/registration_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/welcome_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/change_password_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/profile_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/profile_settings_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/settings_screen.dart';
import 'package:vezem_zerno/features/customs_list/presentations/screens/customs_list_screen.dart';
import 'package:vezem_zerno/main_screen.dart';

part 'router.gr.dart';

// Ensure CustomsListRoute is imported from the generated file
// If not generated, run the build_runner command below

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: WelcomeRoute.page),
    CustomRoute(
      page: LoginRoute.page,
      path: '/login',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute(
      page: RegistrationRoute.page,
      path: '/registration',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute(
      page: PrivacyPolicyRoute.page,
      path: '/privacyPolicy',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute(
      page: PhoneVerificationRoute.page,
      path: '/phoneVerification',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
    AutoRoute(
      page: MainRoute.page,
      path: '/home',
      guards: [AuthGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          page: CustomsListRoute.page,
          path: 'customsList',
          initial: true,
        ),
        AutoRoute(page: ApplicationRoute.page, path: 'aplication'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    CustomRoute(
      page: SettingRoute.page,
      path: '/setting',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute(
      page: ProfileSettingRoute.page,
      path: '/profileSettings',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
    CustomRoute(
      page: ChangePasswordRoute.page,
      path: '/setting',
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      duration: const Duration(milliseconds: 300),
    ),
  ];
}

class AuthGuard extends AutoRouteGuard {
  final AuthBloc authBloc;

  AuthGuard({required this.authBloc});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (authBloc.state is SessionRestored || authBloc.state is LoginSuccess) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.replace(const WelcomeRoute());
    }
  }
}
