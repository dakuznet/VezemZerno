import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/splash_screen.dart';
import 'package:vezem_zerno/features/home/presentations/screens/home_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/login_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/password_recovery_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/registration_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/welcome_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: WelcomeRoute.page),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegistrationRoute.page, path: '/registration'),
    AutoRoute(page: PrivacyPolicyRoute.page, path: '/privacyPolicy'),
    AutoRoute(page: PasswordRecoveryRoute.page, path: '/passwordRecovery'),
    AutoRoute(page: PhoneVerificationRoute.page, path: '/phoneVerification'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      guards: [AuthGuard(authBloc: authBloc)],
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
