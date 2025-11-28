import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0.w,
              bottom: 0.h,
              child: Image.asset(
                'assets/png/wheat.png',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 96.h),
                  Center(
                    child: Image.asset(
                      'assets/png/logo.png',
                      cacheHeight: 230,
                      cacheWidth: 230,
                      width: 230.w,
                      height: 230.h,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  PrimaryButton(
                    text: "Регистрация",
                    onPressed: () =>
                        context.router.push(const RegistrationRoute()),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: TextButton(
                      onPressed: () => context.router.push(const LoginRoute()),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorsConstants.primaryBrownColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        "Уже есть аккаунт",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstants.primaryBrownColor,
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
