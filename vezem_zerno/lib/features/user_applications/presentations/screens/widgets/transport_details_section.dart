import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';
import 'package:vezem_zerno/core/widgets/primary_checkbox_list_tile.dart';

class TransportDetailsSection extends StatefulWidget {
  final ApplicationFormData formData;

  const TransportDetailsSection({super.key, required this.formData});

  @override
  State<TransportDetailsSection> createState() => _TransportDetailsSectionState();
}

class _TransportDetailsSectionState extends State<TransportDetailsSection> {
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
          value: widget.formData.suitableForDumpTrucks,
          onChanged: (value) {
            setState(() {
              widget.formData.suitableForDumpTrucks = value ?? false;
            });
          },
        ),
        SizedBox(height: 16.h),
        PrimaryCheckboxListTile(
          title: 'Перевозчик работает по хартии',
          value: widget.formData.carrierWorksByCharter,
          onChanged: (value) {
            setState(() {
              widget.formData.carrierWorksByCharter = value ?? false;
            });
          },
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Цена перевозки ₽/кг',
          controller: widget.formData.shippingPriceController,
          validator: (value) => _validateNotEmpty(value, 'цену перевозки'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Как оплачиваете простой',
          controller: widget.formData.downtimePaymentController,
          validator: (value) =>
              _validateNotEmpty(value, 'условия оплаты простоя'),
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Допустимая недостача, кг',
          controller: widget.formData.allowableShortageController,
          validator: (value) =>
              _validateNotEmpty(value, 'допустимую недостачу'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Сроки оплаты',
          controller: widget.formData.paymentTermsController,
          validator: (value) => _validateNotEmpty(value, 'сроки оплаты'),
        ),
      ],
    );
  }
}