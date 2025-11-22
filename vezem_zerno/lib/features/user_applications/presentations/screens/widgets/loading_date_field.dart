import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';

class LoadingDateField extends StatelessWidget {
  final ApplicationFormData formData;

  const LoadingDateField({super.key, required this.formData});

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Введите $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectLoadingDate(context),
      child: IgnorePointer(
        child: PrimaryTextFormField(
          autoValidateMode: AutovalidateMode.onUserInteraction,
          readOnly: true,
          labelText: 'Дата начала погрузки',
          controller: formData.loadingDateController,
          validator: (value) =>
              _validateNotEmpty(value, 'дату начала погрузки'),
        ),
      ),
    );
  }

  Future<void> _selectLoadingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      formData.loadingDateController.text =
          "${picked.day}.${picked.month}.${picked.year}";
    }
  }
}
