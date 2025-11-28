import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/core/widgets/primary_checkbox_list_tile.dart';

class TransportDetailsSection extends StatelessWidget {
  final bool suitableForDumpTrucks;
  final ValueChanged<bool> onSuitableForDumpTrucksChanged;
  final ValueChanged<bool> onCarrierWorksByCharterChanged;
  final bool carrierWorksByCharter;
  final TextEditingController shippingPriceController;
  final TextEditingController downtimePaymentController;
  final TextEditingController allowableShortageController;
  final TextEditingController paymentTermsController;

  const TransportDetailsSection({
    super.key,
    required this.suitableForDumpTrucks,
    required this.carrierWorksByCharter,
    required this.shippingPriceController,
    required this.downtimePaymentController,
    required this.allowableShortageController,
    required this.paymentTermsController,
    required this.onSuitableForDumpTrucksChanged,
    required this.onCarrierWorksByCharterChanged,
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
          'Детали перевозки',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        PrimaryCheckboxListTile(
          title: 'Подходят самосвалы',
          value: suitableForDumpTrucks,
          onChanged: (value) {
            if (value != null) {
              onSuitableForDumpTrucksChanged(value);
            }
          },
        ),
        SizedBox(height: 16.h),
        PrimaryCheckboxListTile(
          title: 'Перевозчик работает по хартии',
          value: carrierWorksByCharter,
          onChanged: (value) {
            if (value != null) {
              onCarrierWorksByCharterChanged(value);
            }
          },
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Цена перевозки ₽/кг',
          controller: shippingPriceController,
          validator: (value) => _validateNotEmpty(value, 'цену перевозки'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Как оплачиваете простой',
          controller: downtimePaymentController,
          validator: (value) =>
              _validateNotEmpty(value, 'условия оплаты простоя'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Допустимая недостача, кг',
          controller: allowableShortageController,
          validator: (value) =>
              _validateNotEmpty(value, 'допустимую недостачу'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Сроки оплаты',
          controller: paymentTermsController,
          validator: (value) => _validateNotEmpty(value, 'сроки оплаты'),
        ),
      ],
    );
  }
}
