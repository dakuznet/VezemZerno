import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class RoleSelectionWidget extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onRoleChanged;

  const RoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildRoleButton(
            role: 'customer',
            label: 'Заказчик',
            isSelected: selectedRole == 'customer',
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: _buildRoleButton(
            role: 'carrier',
            label: 'Перевозчик',
            isSelected: selectedRole == 'carrier',
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required String role,
    required String label,
    required bool isSelected,
  }) {
    return ElevatedButton(
      onPressed: () => onRoleChanged(role),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? ColorsConstants.primaryButtonBackgroundColor
            : ColorsConstants.notSelectedTextButtonColor,
        foregroundColor: isSelected
            ? ColorsConstants.notSelectedTextButtonColor
            : ColorsConstants.primaryButtonBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 14.sp,
          color: isSelected
              ? ColorsConstants.primaryBrownColor
              : ColorsConstants.primaryBrownColorWithOpacity,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
