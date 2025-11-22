import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PrimaryLoadingIndicator extends StatelessWidget {
  const PrimaryLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: CircularProgressIndicator(
          strokeWidth: 4.w,
          backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
          color: ColorsConstants.primaryBrownColor,
        ),
      ),
    );
  }
}
