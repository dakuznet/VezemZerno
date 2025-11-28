import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';

class LoadingConditionsSection extends StatelessWidget {
  final TextEditingController loadingDateController;
  final TextEditingController loadingWeightCapacityController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const LoadingConditionsSection({
    super.key,
    required this.loadingDateController,
    required this.selectedCategory,
    required this.loadingWeightCapacityController,
    required this.onCategoryChanged,
  });

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Введите $fieldName';
    }
    return null;
  }

  Future<void> _selectLoadingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      loadingDateController.text =
          "${picked.day}.${picked.month}.${picked.year}";
    }
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
        InkWell(
          onTap: () => _selectLoadingDate(context),
          child: IgnorePointer(
            child: PrimaryTextFormField(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              readOnly: true,
              labelText: 'Дата начала погрузки',
              controller: loadingDateController,
              validator: (value) =>
                  _validateNotEmpty(value, 'дату начала погрузки'),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(12.r),
          style: TextStyle(
            fontSize: 16.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
          initialValue: selectedCategory,
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
            if (value != null) {
              onCategoryChanged(value);
            }
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
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          labelText: 'Грузоподъемность весов на погрузке, тонн',
          validator: (value) =>
              _validateNotEmpty(value, 'грузоподъемность весов'),
          controller: loadingWeightCapacityController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
