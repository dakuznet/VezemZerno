import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/cargo_data_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/loading_location_section.dart';
import 'package:vezem_zerno/core/widgets/primary_divider.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/unloading_location_section.dart';

class BasicSection extends StatelessWidget {
  final ApplicationFormData formData;

  const BasicSection({super.key, required this.formData});

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
        LoadingLocationSection(formData: formData),
        SizedBox(height: 16.h),
        UnloadingLocationSection(formData: formData),
        SizedBox(height: 16.h),
        const PrimaryDivider(),
        SizedBox(height: 16.h),
        CargoDataSection(formData: formData),
      ],
    );
  }
}
