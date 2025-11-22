import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';

class CargoDataSection extends StatelessWidget {
  final ApplicationFormData formData;

  const CargoDataSection({super.key, required this.formData});

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Введите $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Введите расстояние, км',
          controller: formData.distanceController,
          validator: (value) => _validateNotEmpty(value, 'расстояние'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Введите культуру',
          controller: formData.cropController,
          validator: (value) => _validateNotEmpty(value, 'культуру'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Введите объём перевозки, тонн',
          controller: formData.transportationVolumeController,
          validator: (value) => _validateNotEmpty(value, 'объём перевозки'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
