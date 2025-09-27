import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';

class ProfileErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ProfileErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: ColorsConstants.primaryBrownColorWithOpacity,
          ),
          SizedBox(height: 16.h),
          Text(
            'Возникла ошибка при загрузке профиля',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          PrimaryButton(text: 'Повторить', onPressed: onRetry),
        ],
      ),
    );
  }
}