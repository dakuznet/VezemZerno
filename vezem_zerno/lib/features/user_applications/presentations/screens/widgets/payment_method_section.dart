import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/payment_method_radio_tile.dart';

class PaymentMethodSection extends StatelessWidget {
  final String paymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const PaymentMethodSection({
    super.key,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
  });

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
              groupValue: paymentMethod,
              onChanged: (value) {
                onPaymentMethodChanged(value);
                            },
            ),
            SizedBox(height: 16.h),
            PaymentMethodRadioTile(
              title: 'Безналичные',
              value: 'Безналичные',
              groupValue: paymentMethod,
              onChanged: (value) {
                onPaymentMethodChanged(value);
                            },
            ),
          ],
        ),
      ],
    );
  }
}
