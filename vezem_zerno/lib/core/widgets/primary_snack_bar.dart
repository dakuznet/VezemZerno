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
      duration: const Duration(seconds: 5),
      content: Text(
        text,
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 14.sp,
          color: ColorsConstants.primaryBrownColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0.r),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: 2.0.w,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
