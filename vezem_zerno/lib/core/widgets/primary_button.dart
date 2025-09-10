import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Разрешаем null

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

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
          borderRadius: BorderRadius.circular(32.r),
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
          fontSize: 16.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
