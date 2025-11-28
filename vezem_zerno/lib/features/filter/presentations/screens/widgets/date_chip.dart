import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

class DateChip extends StatelessWidget {
  const DateChip({super.key, required this.label, required this.value, required this.isSelected, this.onSelected});
  final String label; 
  final DateFilter value;
  final bool isSelected;
  final Function(bool)? onSelected;
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: ColorsConstants.primaryBrownColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: ColorsConstants.primaryButtonBackgroundColor,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      side: BorderSide.none,
      checkmarkColor: ColorsConstants.primaryBrownColor,
    );
  }
}