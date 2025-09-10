import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

@RoutePage()
class CustomsListScreen extends StatelessWidget {
  const CustomsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.backgroundColor,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.w).r,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Здесь будет отображаться список с Вашими заявками',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}