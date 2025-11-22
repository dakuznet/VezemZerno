import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';

class LoadingMethodDropdown extends StatelessWidget {
  final ApplicationFormData formData;

  const LoadingMethodDropdown({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      borderRadius: BorderRadius.circular(12.r),
      style: TextStyle(
        fontSize: 16.sp,
        color: ColorsConstants.primaryBrownColor,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      initialValue: 'Не указано',
      items:
          const [
            'Не указано',
            'Вертикальный',
            'Зерномет',
            'Элеватор',
            'Кун',
            'Манитару',
            'С поля',
            'Кара',
            'Амкадор',
            'Зерномет и кун',
            'Зерномет и маниту',
          ].map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
      onChanged: (value) {
        formData.selectedCategory = value!;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        labelText: 'Выберите способ погрузки',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: ColorsConstants.primaryBrownColorWithOpacity,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide(color: Colors.red, width: 2.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16).r,
          borderSide: BorderSide(color: Colors.red, width: 2.w),
        ),
      ),
    );
  }
}
