import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class NumberField extends StatelessWidget {
  const NumberField({super.key, required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: ColorsConstants.primaryBrownColor),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: ColorsConstants.primaryBrownColorWithOpacity,
        ),
        hintText: hintText,
        filled: true,
        fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12).r,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12).r,
          borderSide: BorderSide(
            color: ColorsConstants.primaryBrownColor,
            width: 2.0.w,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: ColorsConstants.primaryBrownColorWithOpacity,
        ),
      ),
    );
  }
}