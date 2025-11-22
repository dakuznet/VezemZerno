import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';

class ActionButtonsSection extends StatelessWidget {
  final ApplicationEntity application;
  final bool isCustomer;
  final VoidCallback onMarkDelivered;
  final VoidCallback onMarkCompleted;

  const ActionButtonsSection({
    super.key,
    required this.application,
    required this.isCustomer,
    required this.onMarkDelivered,
    required this.onMarkCompleted,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCustomer && application.status == 'processing') {
      return PrimaryButton(
        text: application.delivered
            ? 'Заявка выполнена'
            : 'Отметить выполненной',
        onPressed: application.delivered ? null : onMarkDelivered,
      );
    }

    if (isCustomer && application.status == 'processing') {
      return PrimaryButton(
        text: 'Завершить заявку',
        onPressed: onMarkCompleted,
      );
    }

    return const SizedBox.shrink();
  }
}
