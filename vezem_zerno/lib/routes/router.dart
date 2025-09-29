import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/splash_screen.dart';
import 'package:vezem_zerno/features/applications_list/presentations/screens/application_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/login_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/registration_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/welcome_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/change_password_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/profile_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/profile_settings_screen.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/settings_screen.dart';
import 'package:vezem_zerno/features/user_application_list/presentations/screens/user_applications_list_screen.dart';
import 'package:vezem_zerno/core/main_screen.dart';

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
    AutoRoute(page: PrivacyPolicyRoute.page, path: '/privacy-policy'),
    AutoRoute(page: PhoneVerificationRoute.page, path: '/phone-verification'),
    AutoRoute(
      page: MainRoute.page,
      path: '/home',
      guards: [AuthGuard(authBloc: authBloc)],
      children: [
        AutoRoute(
          page: ApplicationsListRoute.page,
          path: 'application-list',
          initial: true,
        ),
        AutoRoute(
          page: UserApplicationsListRoute.page,
          path: 'user-applications-list',
        ),

        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    AutoRoute(page: SettingRoute.page, path: '/settings'),
    AutoRoute(page: ProfileSettingRoute.page, path: '/profile-settings'),
    AutoRoute(page: ChangePasswordRoute.page, path: '/change-password'),
  ];
}

class AuthGuard extends AutoRouteGuard {
  final AuthBloc authBloc;

  AuthGuard({required this.authBloc});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final currentState = authBloc.state;

    if (currentState is SessionRestored || currentState is LoginSuccess) {
      resolver.next(true);
    } else if (currentState is NoInternetConnection) {
      await _waitForConnection(resolver, router);
    } else if (currentState is AuthInitial) {
      await _waitForAuthResolution(resolver, router);
    } else {
      resolver.next(false);
      router.replace(const WelcomeRoute());
    }
  }

  Future<void> _waitForConnection(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final completer = Completer<bool>();
    final subscription = authBloc.stream.listen((state) {
      if (state is SessionRestored || state is LoginSuccess) {
        completer.complete(true);
      } else if (state is Unauthenticated || state is AuthFailure) {
        completer.complete(false);
      }
    });

    final result = await completer.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () => false,
    );

    await subscription.cancel();

    if (result) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.replace(const WelcomeRoute());
    }
  }

  Future<void> _waitForAuthResolution(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final completer = Completer<bool>();
    final subscription = authBloc.stream.listen((state) {
      if (state is SessionRestored || state is LoginSuccess) {
        completer.complete(true);
      } else if (state is Unauthenticated || state is AuthFailure) {
        completer.complete(false);
      }
    });

    final result = await completer.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () => false,
    );

    await subscription.cancel();

    if (result) {
      resolver.next(true);
    } else {
      resolver.next(false);
      router.replace(const WelcomeRoute());
    }
  }
}
