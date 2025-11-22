import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/basic_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/comment_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/loading_conditions_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/payment_method_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/transport_details_section.dart';

class ApplicationFormContent extends StatelessWidget {
  final ApplicationFormData formData;
  final bool isLoading;
  final VoidCallback? onSubmit;

  const ApplicationFormContent({
    super.key,
    required this.formData,
    required this.isLoading,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BasicSection(formData: formData),
          SizedBox(height: 32.h),
          LoadingConditionsSection(formData: formData),
          SizedBox(height: 32.h),
          TransportDetailsSection(formData: formData),
          SizedBox(height: 32.h),
          PaymentMethodSection(formData: formData),
          SizedBox(height: 32.h),
          CommentSection(formData: formData),
          SizedBox(height: 32.h),
          PrimaryButton(
            text: 'Опубликовать заявку',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
