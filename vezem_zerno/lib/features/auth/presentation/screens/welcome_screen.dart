import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        bottom: false,
        left: false,
        child: Stack(
          children: [
            Positioned(
              left: 0.w,
              bottom: 0.h,
              child: SvgPicture.asset(
                'assets/svg/wheat.svg',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.0.w).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 96.h),
                  SvgPicture.asset(
                    'assets/svg/logo.svg',
                    width: 230.w,
                    height: 230.h,
                  ),
                  SizedBox(height: 48.h),
                  PrimaryButton(
                    text: "Регистрация",
                    onPressed: () {
                      AutoRouter.of(context).push(const RegistrationRoute());
                    },
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: InkWell(
                      onTap: () =>
                          AutoRouter.of(context).push(const LoginRoute()),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0.w,
                          vertical: 8.h,
                        ),
                        child: Text(
                          "Уже есть аккаунт",
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorsConstants.primaryBrownColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
