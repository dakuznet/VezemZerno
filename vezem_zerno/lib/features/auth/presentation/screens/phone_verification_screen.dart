import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/colors_constants.dart';

@RoutePage()
class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorsConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ColorsConstants.primaryBrownColor,
          iconSize: 30.r,
          onPressed: () => AutoRouter.of(context).back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r).r,
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                'ФУНКЦИЯ В ДОРАБОТКЕ...',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstants.primaryBrownColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
