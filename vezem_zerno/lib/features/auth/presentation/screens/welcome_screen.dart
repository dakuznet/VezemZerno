import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  static const _wheatAssetPath = 'assets/svg/wheat.svg';
  static const _logoAssetPath = 'assets/svg/logo.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Stack(children: [_buildBackground(), _buildContent()]);
  }

  Widget _buildBackground() {
    return Positioned(
      left: 0.w,
      bottom: 0.h,
      child: SvgPicture.asset(
        _wheatAssetPath,
        fit: BoxFit.cover,
        placeholderBuilder: (context) =>
            Container(color: ColorsConstants.backgroundColor),
      ),
    );
  }

  Widget _buildContent() {
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
          _buildLoginTextButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: SvgPicture.asset(
        _logoAssetPath,
        width: 230.w,
        height: 230.h,
        placeholderBuilder: (context) => Container(
          width: 230.w,
          height: 230.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: 80.r,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        semanticsLabel: 'Логотип Vezem Zerno',
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return PrimaryButton(
      text: "Регистрация",
      onPressed: _navigateToRegistration,
    );
  }

  Widget _buildLoginTextButton() {
    return Center(
      child: TextButton(
        onPressed: _navigateToLogin,
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
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ),
    );
  }

  void _navigateToRegistration() {
    if (mounted) {
      context.pushRoute(const RegistrationRoute());
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      context.pushRoute(const LoginRoute());
    }
  }
}
