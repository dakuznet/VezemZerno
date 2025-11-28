// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [ApplicationResponsesScreen]
class ApplicationResponsesRoute
    extends PageRouteInfo<ApplicationResponsesRouteArgs> {
  ApplicationResponsesRoute({
    Key? key,
    required String applicationId,
    List<PageRouteInfo>? children,
  }) : super(
         ApplicationResponsesRoute.name,
         args: ApplicationResponsesRouteArgs(
           key: key,
           applicationId: applicationId,
         ),
         initialChildren: children,
       );

  static const String name = 'ApplicationResponsesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ApplicationResponsesRouteArgs>();
      return ApplicationResponsesScreen(
        key: args.key,
        applicationId: args.applicationId,
      );
    },
  );
}

class ApplicationResponsesRouteArgs {
  const ApplicationResponsesRouteArgs({this.key, required this.applicationId});

  final Key? key;

  final String applicationId;

  @override
  String toString() {
    return 'ApplicationResponsesRouteArgs{key: $key, applicationId: $applicationId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ApplicationResponsesRouteArgs) return false;
    return key == other.key && applicationId == other.applicationId;
  }

  @override
  int get hashCode => key.hashCode ^ applicationId.hashCode;
}

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
/// [CreateApplicationScreen]
class CreateApplicationRoute extends PageRouteInfo<void> {
  const CreateApplicationRoute({List<PageRouteInfo>? children})
    : super(CreateApplicationRoute.name, initialChildren: children);

  static const String name = 'CreateApplicationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateApplicationScreen();
    },
  );
}

/// generated route for
/// [FilterScreen]
class FilterRoute extends PageRouteInfo<FilterRouteArgs> {
  FilterRoute({
    Key? key,
    required ApplicationFilter initialFilter,
    List<PageRouteInfo>? children,
  }) : super(
         FilterRoute.name,
         args: FilterRouteArgs(key: key, initialFilter: initialFilter),
         initialChildren: children,
       );

  static const String name = 'FilterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FilterRouteArgs>();
      return FilterScreen(key: args.key, initialFilter: args.initialFilter);
    },
  );
}

class FilterRouteArgs {
  const FilterRouteArgs({this.key, required this.initialFilter});

  final Key? key;

  final ApplicationFilter initialFilter;

  @override
  String toString() {
    return 'FilterRouteArgs{key: $key, initialFilter: $initialFilter}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FilterRouteArgs) return false;
    return key == other.key && initialFilter == other.initialFilter;
  }

  @override
  int get hashCode => key.hashCode ^ initialFilter.hashCode;
}

/// generated route for
/// [InfoAboutApplicationMyResponsesScreen]
class InfoAboutApplicationMyResponsesRoute
    extends PageRouteInfo<InfoAboutApplicationMyResponsesRouteArgs> {
  InfoAboutApplicationMyResponsesRoute({
    Key? key,
    required ApplicationEntity application,
    List<PageRouteInfo>? children,
  }) : super(
         InfoAboutApplicationMyResponsesRoute.name,
         args: InfoAboutApplicationMyResponsesRouteArgs(
           key: key,
           application: application,
         ),
         initialChildren: children,
       );

  static const String name = 'InfoAboutApplicationMyResponsesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InfoAboutApplicationMyResponsesRouteArgs>();
      return InfoAboutApplicationMyResponsesScreen(
        key: args.key,
        application: args.application,
      );
    },
  );
}

class InfoAboutApplicationMyResponsesRouteArgs {
  const InfoAboutApplicationMyResponsesRouteArgs({
    this.key,
    required this.application,
  });

  final Key? key;

  final ApplicationEntity application;

  @override
  String toString() {
    return 'InfoAboutApplicationMyResponsesRouteArgs{key: $key, application: $application}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InfoAboutApplicationMyResponsesRouteArgs) return false;
    return key == other.key && application == other.application;
  }

  @override
  int get hashCode => key.hashCode ^ application.hashCode;
}

/// generated route for
/// [InfoAboutApplicationScreen]
class InfoAboutApplicationRoute
    extends PageRouteInfo<InfoAboutApplicationRouteArgs> {
  InfoAboutApplicationRoute({
    Key? key,
    required ApplicationEntity application,
    List<PageRouteInfo>? children,
  }) : super(
         InfoAboutApplicationRoute.name,
         args: InfoAboutApplicationRouteArgs(
           key: key,
           application: application,
         ),
         initialChildren: children,
       );

  static const String name = 'InfoAboutApplicationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InfoAboutApplicationRouteArgs>();
      return InfoAboutApplicationScreen(
        key: args.key,
        application: args.application,
      );
    },
  );
}

class InfoAboutApplicationRouteArgs {
  const InfoAboutApplicationRouteArgs({this.key, required this.application});

  final Key? key;

  final ApplicationEntity application;

  @override
  String toString() {
    return 'InfoAboutApplicationRouteArgs{key: $key, application: $application}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InfoAboutApplicationRouteArgs) return false;
    return key == other.key && application == other.application;
  }

  @override
  int get hashCode => key.hashCode ^ application.hashCode;
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
/// [MapScreen]
class MapRoute extends PageRouteInfo<void> {
  const MapRoute({List<PageRouteInfo>? children})
    : super(MapRoute.name, initialChildren: children);

  static const String name = 'MapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MapScreen();
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
    required String name,
    required String surname,
    required String organization,
    required String role,
    List<PageRouteInfo>? children,
  }) : super(
         PhoneVerificationRoute.name,
         args: PhoneVerificationRouteArgs(
           key: key,
           phone: phone,
           password: password,
           name: name,
           surname: surname,
           organization: organization,
           role: role,
         ),
         rawPathParams: {
           'phone': phone,
           'password': password,
           'name': name,
           'surname': surname,
           'organization': organization,
           'role': role,
         },
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
          name: pathParams.getString('name'),
          surname: pathParams.getString('surname'),
          organization: pathParams.getString('organization'),
          role: pathParams.getString('role'),
        ),
      );
      return PhoneVerificationScreen(
        key: args.key,
        phone: args.phone,
        password: args.password,
        name: args.name,
        surname: args.surname,
        organization: args.organization,
        role: args.role,
      );
    },
  );
}

class PhoneVerificationRouteArgs {
  const PhoneVerificationRouteArgs({
    this.key,
    required this.phone,
    required this.password,
    required this.name,
    required this.surname,
    required this.organization,
    required this.role,
  });

  final Key? key;

  final String phone;

  final String password;

  final String name;

  final String surname;

  final String organization;

  final String role;

  @override
  String toString() {
    return 'PhoneVerificationRouteArgs{key: $key, phone: $phone, password: $password, name: $name, surname: $surname, organization: $organization, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhoneVerificationRouteArgs) return false;
    return key == other.key &&
        phone == other.phone &&
        password == other.password &&
        name == other.name &&
        surname == other.surname &&
        organization == other.organization &&
        role == other.role;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phone.hashCode ^
      password.hashCode ^
      name.hashCode ^
      surname.hashCode ^
      organization.hashCode ^
      role.hashCode;
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
class ProfileSettingRoute extends PageRouteInfo<ProfileSettingRouteArgs> {
  ProfileSettingRoute({
    Key? key,
    required UserEntity? user,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileSettingRoute.name,
         args: ProfileSettingRouteArgs(key: key, user: user),
         initialChildren: children,
       );

  static const String name = 'ProfileSettingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileSettingRouteArgs>();
      return ProfileSettingScreen(key: args.key, user: args.user);
    },
  );
}

class ProfileSettingRouteArgs {
  const ProfileSettingRouteArgs({this.key, required this.user});

  final Key? key;

  final UserEntity? user;

  @override
  String toString() {
    return 'ProfileSettingRouteArgs{key: $key, user: $user}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileSettingRouteArgs) return false;
    return key == other.key && user == other.user;
  }

  @override
  int get hashCode => key.hashCode ^ user.hashCode;
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
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
    : super(ResetPasswordRoute.name, initialChildren: children);

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ResetPasswordScreen();
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
/// [UserApplicationInfoScreen]
class UserApplicationInfoRoute
    extends PageRouteInfo<UserApplicationInfoRouteArgs> {
  UserApplicationInfoRoute({
    Key? key,
    required ApplicationEntity application,
    List<PageRouteInfo>? children,
  }) : super(
         UserApplicationInfoRoute.name,
         args: UserApplicationInfoRouteArgs(key: key, application: application),
         initialChildren: children,
       );

  static const String name = 'UserApplicationInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserApplicationInfoRouteArgs>();
      return UserApplicationInfoScreen(
        key: args.key,
        application: args.application,
      );
    },
  );
}

class UserApplicationInfoRouteArgs {
  const UserApplicationInfoRouteArgs({this.key, required this.application});

  final Key? key;

  final ApplicationEntity application;

  @override
  String toString() {
    return 'UserApplicationInfoRouteArgs{key: $key, application: $application}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserApplicationInfoRouteArgs) return false;
    return key == other.key && application == other.application;
  }

  @override
  int get hashCode => key.hashCode ^ application.hashCode;
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
