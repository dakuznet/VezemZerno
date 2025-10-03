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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: Stack(children: [_buildBackground(), _buildContent(context)]),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      left: 0.w,
      bottom: 0.h,
      child: Image.asset(
        'assets/png/wheat.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 96.h),
          _buildLogo(),
          SizedBox(height: 48.h),
          _buildRegistrationButton(),
          SizedBox(height: 16.h),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/png/logo.png',
        cacheHeight: 230,
        cacheWidth: 230,
        width: 230.w,
        height: 230.h,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return PrimaryButton(
      text: "Регистрация",
      onPressed: () => AutoRouter.of(context).push(const RegistrationRoute()),
    );
  }

  Widget _buildLoginButton() {
    return Center(
      child: TextButton(
        onPressed: () => AutoRouter.of(context).push(const LoginRoute()),
        style: TextButton.styleFrom(
          foregroundColor: ColorsConstants.primaryBrownColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          "Уже есть аккаунт",
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ),
    );
  }
}
