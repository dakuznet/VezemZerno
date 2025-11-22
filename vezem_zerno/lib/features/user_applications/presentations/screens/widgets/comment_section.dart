import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';

class CommentSection extends StatelessWidget {
  final ApplicationFormData formData;

  const CommentSection({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    return PrimaryTextFormField(
      readOnly: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Комментарий к заявке',
      controller: formData.descriptionController,
      maxLines: 5,
    );
  }
}
