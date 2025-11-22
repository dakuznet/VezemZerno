import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/payment_method_radio_tile.dart';

class PaymentMethodSection extends StatefulWidget {
  final ApplicationFormData formData;

  const PaymentMethodSection({super.key, required this.formData});

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Способ оплаты',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Column(
          children: [
            PaymentMethodRadioTile(
              title: 'Наличные',
              value: 'Наличные',
              groupValue: widget.formData.paymentMethod,
              onChanged: (value) {
                setState(() {
                  widget.formData.paymentMethod = value;
                });
              },
            ),
            SizedBox(height: 16.h),
            PaymentMethodRadioTile(
              title: 'Безналичные',
              value: 'Безналичные',
              groupValue: widget.formData.paymentMethod,
              onChanged: (value) {
                setState(() {
                  widget.formData.paymentMethod = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
