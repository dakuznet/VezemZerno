// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PaymentMethodRadioTile extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String> onChanged;

  const PaymentMethodRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: RadioListTile<String>(
        activeColor: ColorsConstants.primaryBrownColor,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: (String? value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
