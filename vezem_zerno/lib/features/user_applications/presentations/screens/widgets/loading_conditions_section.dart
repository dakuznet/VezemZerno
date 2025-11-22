import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/loading_date_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/loading_method_dropdown.dart';

class LoadingConditionsSection extends StatelessWidget {
  final ApplicationFormData formData;

  const LoadingConditionsSection({super.key, required this.formData});

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
          'Условия погрузки',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 16.h),
        LoadingDateField(formData: formData),
        SizedBox(height: 16.h),
        LoadingMethodDropdown(formData: formData),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Грузоподъемность весов на погрузке, тонн',
          validator: (value) =>
              _validateNotEmpty(value, 'грузоподъемность весов'),
          controller: formData.loadingWeightCapacityController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
