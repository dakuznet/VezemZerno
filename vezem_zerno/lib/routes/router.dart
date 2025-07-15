import 'package:auto_route/auto_route.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/login_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/password_recovery_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/privacy_policy_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/registration_screen.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/welcome_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: WelcomeRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegistrationRoute.page, path: '/registration'),
    AutoRoute(page: PrivacyPolicyRoute.page, path: '/privacyPolicy'),
    AutoRoute(page: PasswordRecoveryRoute.page, path: '/passwordRecovery'),
    AutoRoute(page: PhoneVerificationRoute.page, path: '/phoneVerification'),
  ];
}
