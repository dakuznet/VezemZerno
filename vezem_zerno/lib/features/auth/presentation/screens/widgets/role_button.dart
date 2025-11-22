import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class RoleButton extends StatelessWidget {
  const RoleButton({
    super.key,
    required this.role,
    required this.label,
    required this.onPressed,
    required this.selectedRole,
  });

  final String role;
  final String label;
  final String? selectedRole;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedRole == role;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? ColorsConstants.primaryButtonBackgroundColor
            : ColorsConstants.notSelectedTextButtonColor,
        foregroundColor: isSelected
            ? ColorsConstants.notSelectedTextButtonColor
            : ColorsConstants.primaryButtonBackgroundColor,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          color: isSelected
              ? ColorsConstants.primaryBrownColor
              : ColorsConstants.primaryBrownColorWithOpacity,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
