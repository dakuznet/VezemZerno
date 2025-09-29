import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class ErrorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRetry;

  const ErrorAppBar({super.key, required this.onRetry});

  @override
  Size get preferredSize => Size.fromHeight(150.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150.h,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
      ),
    );
  }
}
