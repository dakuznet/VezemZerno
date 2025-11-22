import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';

class UnloadingLocationSection extends StatelessWidget {
  final ApplicationFormData formData;

  const UnloadingLocationSection({super.key, required this.formData});

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Введите $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Место выгрузки",
          style: TextStyle(
            fontSize: 16.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Регион выгрузки',
          controller: formData.unloadingRegionController,
          validator: (value) => _validateNotEmpty(value, 'регион выгрузки'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Населённый пункт выгрузки',
          controller: formData.unloadingLocalityController,
          validator: (value) =>
              _validateNotEmpty(value, 'населённый пункт выгрузки'),
        ),
      ],
    );
  }
}
