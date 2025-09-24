import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/constants/string_constants.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorsConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ColorsConstants.primaryBrownColor,
          iconSize: 30.r,
          onPressed: () => AutoRouter.of(context).back(),
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Text(
            StringConstants.textPrivacyPolicy,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.5,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ),
      ),
    );
  }
}
