import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          AutoRouter.of(context).replaceAll([const ApplicationRoute()]);
        } else if (state is Unauthenticated || state is AuthFailure) {
          AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: ColorsConstants.backgroundColor,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is NoInternetConnection) {
              return Scaffold(
                backgroundColor: ColorsConstants.backgroundColor,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 64.sp,
                        color: ColorsConstants.primaryBrownColorWithOpacity,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Отсутствует соединение с интернетом',
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: ColorsConstants.primaryBrownColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(RestoreSessionEvent());
                        },
                        child: Text(
                          'Повторить',
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: ColorsConstants.primaryBrownColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor:
                    ColorsConstants.primaryTextFormFieldBackgorundColor,
                color: ColorsConstants.primaryBrownColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
