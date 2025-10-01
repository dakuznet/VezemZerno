import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class ProfileErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ProfileErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'Возникла ошибка при загрузке профиля',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: ColorsConstants.primaryBrownColor,
              ),
              child: Text(
                'Повторить',
                style: TextStyle(
                  color: ColorsConstants.primaryBrownColor,
                  fontSize: 14.sp,
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
