import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PrimarySnackBar {
  static void show({
    required BuildContext context,
    required String text,
    Color? borderColor,
  }) {
    final snackBar = SnackBar(
      elevation: 0.sp,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(16.w),
      content: Text(
        text,
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 14.sp,
          color: ColorsConstants.primaryBrownColor,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: 2.0.w,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
