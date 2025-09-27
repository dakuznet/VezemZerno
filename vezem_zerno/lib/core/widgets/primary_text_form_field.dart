import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PrimaryTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool readOnly;
  final FloatingLabelBehavior? labelBehavior;
  final Function()? onTap;
  final AutovalidateMode? autoValidateMode;
  final List<String>? autofillHints;

  const PrimaryTextFormField({
    super.key,
    required this.readOnly,
    this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.labelBehavior,
    this.autoValidateMode,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontFamily: 'Unbounded',
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
        color: ColorsConstants.primaryBrownColor,
      ),
      autofillHints: autofillHints,
      readOnly: readOnly,
      textCapitalization: TextCapitalization.words,
      autovalidateMode: autoValidateMode,
      onTap: onTap,
      cursorColor: ColorsConstants.primaryBrownColor,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        labelText: labelText,
        floatingLabelBehavior: labelBehavior,
        labelStyle: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: ColorsConstants.primaryBrownColorWithOpacity,
        ),
        prefixIcon: prefixIcon,
        prefixIconColor: ColorsConstants.primaryBrownColor,
        suffixIcon: suffixIcon,
        suffixIconColor: ColorsConstants.primaryBrownColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide(
            color: ColorsConstants.primaryBrownColor,
            width: 2.0.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide(color: Colors.red, width: 2.0.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide(color: Colors.red, width: 2.0.w),
        ),
      ),
    );
  }
}
