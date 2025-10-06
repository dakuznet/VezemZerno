// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [ApplicationsListScreen]
class ApplicationsListRoute extends PageRouteInfo<void> {
  const ApplicationsListRoute({List<PageRouteInfo>? children})
    : super(ApplicationsListRoute.name, initialChildren: children);

  static const String name = 'ApplicationsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ApplicationsListScreen();
    },
  );
}

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [CreateRequestScreen]
class CreateRequestRoute extends PageRouteInfo<void> {
  const CreateRequestRoute({List<PageRouteInfo>? children})
    : super(CreateRequestRoute.name, initialChildren: children);

  static const String name = 'CreateRequestRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateRequestScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [PhoneVerificationScreen]
class PhoneVerificationRoute extends PageRouteInfo<PhoneVerificationRouteArgs> {
  PhoneVerificationRoute({
    Key? key,
    required String phone,
    required String password,
    List<PageRouteInfo>? children,
  }) : super(
         PhoneVerificationRoute.name,
         args: PhoneVerificationRouteArgs(
           key: key,
           phone: phone,
           password: password,
         ),
         rawPathParams: {'phone': phone, 'password': password},
         initialChildren: children,
       );

  static const String name = 'PhoneVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PhoneVerificationRouteArgs>(
        orElse: () => PhoneVerificationRouteArgs(
          phone: pathParams.getString('phone'),
          password: pathParams.getString('password'),
        ),
      );
      return PhoneVerificationScreen(
        key: args.key,
        phone: args.phone,
        password: args.password,
      );
    },
  );
}

class PhoneVerificationRouteArgs {
  const PhoneVerificationRouteArgs({
    this.key,
    required this.phone,
    required this.password,
  });

  final Key? key;

  final String phone;

  final String password;

  @override
  String toString() {
    return 'PhoneVerificationRouteArgs{key: $key, phone: $phone, password: $password}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhoneVerificationRouteArgs) return false;
    return key == other.key &&
        phone == other.phone &&
        password == other.password;
  }

  @override
  int get hashCode => key.hashCode ^ phone.hashCode ^ password.hashCode;
}

/// generated route for
/// [PrivacyPolicyScreen]
class PrivacyPolicyRoute extends PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<PageRouteInfo>? children})
    : super(PrivacyPolicyRoute.name, initialChildren: children);

  static const String name = 'PrivacyPolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPolicyScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [ProfileSettingScreen]
class ProfileSettingRoute extends PageRouteInfo<void> {
  const ProfileSettingRoute({List<PageRouteInfo>? children})
    : super(ProfileSettingRoute.name, initialChildren: children);

  static const String name = 'ProfileSettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileSettingScreen();
    },
  );
}

/// generated route for
/// [RegistrationScreen]
class RegistrationRoute extends PageRouteInfo<void> {
  const RegistrationRoute({List<PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegistrationScreen();
    },
  );
}

/// generated route for
/// [SettingScreen]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
    : super(SettingRoute.name, initialChildren: children);

  static const String name = 'SettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [UserApplicationsListScreen]
class UserApplicationsListRoute extends PageRouteInfo<void> {
  const UserApplicationsListRoute({List<PageRouteInfo>? children})
    : super(UserApplicationsListRoute.name, initialChildren: children);

  static const String name = 'UserApplicationsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserApplicationsListScreen();
    },
  );
}

/// generated route for
/// [WelcomeScreen]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomeScreen();
    },
  );
}
