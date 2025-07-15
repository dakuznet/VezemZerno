import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/colors_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        elevation: 4.r,
        fixedSize: Size(320.w, 60.h),
        backgroundColor: ColorsConstants.primaryButtonBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(32.r),
          side: BorderSide(
            color: ColorsConstants.primaryButtonBorderColor,
            width: 3.w,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorsConstants.primaryBrownColor,
          fontSize: 18.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
