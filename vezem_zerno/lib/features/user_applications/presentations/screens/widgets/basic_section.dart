import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/core/widgets/primary_divider.dart';

class BasicSection extends StatelessWidget {
  final TextEditingController loadingRegionController;
  final TextEditingController loadingLocalityController;

  final TextEditingController unloadingRegionController;
  final TextEditingController unloadingLocalityController;

  final TextEditingController cropController;
  final TextEditingController distanceController;
  final TextEditingController transportationVolumeController;

  const BasicSection({
    super.key,
    required this.loadingRegionController,
    required this.loadingLocalityController,
    required this.unloadingRegionController,
    required this.unloadingLocalityController,
    required this.cropController,
    required this.distanceController,
    required this.transportationVolumeController,
  });

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
          "Основное",
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Место погрузки",
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
          labelText: 'Регион погрузки',
          controller: loadingRegionController,
          validator: (value) => _validateNotEmpty(value, 'регион погрузки'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Населённый пункт погрузки',
          controller: loadingLocalityController,
          validator: (value) =>
              _validateNotEmpty(value, 'населённый пункт погрузки'),
        ),
        SizedBox(height: 16.h),
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
          controller: unloadingRegionController,
          validator: (value) => _validateNotEmpty(value, 'регион выгрузки'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Населённый пункт выгрузки',
          controller: unloadingLocalityController,
          validator: (value) =>
              _validateNotEmpty(value, 'населённый пункт выгрузки'),
        ),
        SizedBox(height: 16.h),
        const PrimaryDivider(),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Введите расстояние, км',
          controller: distanceController,
          validator: (value) => _validateNotEmpty(value, 'расстояние'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Введите культуру',
          controller: cropController,
          validator: (value) => _validateNotEmpty(value, 'культуру'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Введите объём перевозки, тонн',
          controller: transportationVolumeController,
          validator: (value) => _validateNotEmpty(value, 'объём перевозки'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
