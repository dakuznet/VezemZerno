// profile_text_field_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';

class ProfileSettingsTextFieldSection extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isSaving;
  final bool readOnly;

  const ProfileSettingsTextFieldSection({
    super.key,
    required this.label,
    required this.controller,
    required this.isSaving,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: readOnly || isSaving,
          controller: controller,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: label,
          suffixIcon: readOnly
              ? null
              : Icon(
                  Icons.drive_file_rename_outline,
                  size: 24.sp,
                  color: ColorsConstants.primaryBrownColor,
                ),
        ),
      ],
    );
  }
}
