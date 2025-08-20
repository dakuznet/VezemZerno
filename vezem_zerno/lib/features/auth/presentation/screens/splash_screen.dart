import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SessionRestored || state is LoginSuccess) {
          AutoRouter.of(context).replaceAll([const HomeRoute()]);
        } else if (state is Unauthenticated || state is AuthFailure) {
          AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: ColorsConstants.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ),
    );
  }
}
