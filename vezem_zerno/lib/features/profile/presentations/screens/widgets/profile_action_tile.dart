import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class ProfileActionTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final Size? iconSize;

  const ProfileActionTile({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(32.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: iconSize?.width ?? 24.w,
                height: iconSize?.height ?? 24.h,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
