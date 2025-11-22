import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class ApplicationInfoCard extends StatelessWidget {
  final String title;

  final List<Widget> children;

  const ApplicationInfoCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            SizedBox(height: 8.h),
            ...children,
          ],
        ),
      ),
    );
  }
}
