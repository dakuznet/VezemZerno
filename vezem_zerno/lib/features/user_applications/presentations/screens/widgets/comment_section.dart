import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';

class CommentSection extends StatelessWidget {
  final TextEditingController descriptionController;

  const CommentSection({super.key, required this.descriptionController});

  @override
  Widget build(BuildContext context) {
    return PrimaryTextFormField(
      readOnly: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      labelText: 'Комментарий к заявке',
      controller: descriptionController,
      maxLines: 5,
    );
  }
}
