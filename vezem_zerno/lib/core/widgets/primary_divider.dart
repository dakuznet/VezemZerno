import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PrimaryDivider extends StatelessWidget {
  const PrimaryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Divider(color: ColorsConstants.primaryBrownColor, thickness: 1.sp),
    );
  }
}
