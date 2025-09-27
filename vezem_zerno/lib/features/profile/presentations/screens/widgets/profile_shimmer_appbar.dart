import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class ProfileShimmerAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfileShimmerAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(150.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
      ),
      toolbarHeight: 150.h,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1000),
        child: Row(
          children: [
            Container(
              width: 100.r,
              height: 100.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120.w, height: 20.h, color: Colors.white),
                  SizedBox(height: 8.h),
                  Container(width: 80.w, height: 16.h, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
