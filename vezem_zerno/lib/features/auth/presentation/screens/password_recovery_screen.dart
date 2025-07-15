import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vezem_zerno/core/colors_constants.dart';
import 'package:vezem_zerno/features/auth/presentation/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/presentation/widgets/primary_text_form_field.dart';

@RoutePage()
class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _phoneController = TextEditingController();

  bool _isFirstInteraction = true;

  late MaskTextInputFormatter phoneMaskFormatter;

  @override
  void initState() {
    super.initState();

    phoneMaskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ColorsConstants.primaryBrownColor,
          iconSize: 30.r,
          onPressed: () => AutoRouter.of(context).back(),
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.r).r,
          child: Column(
            children: [
              // Text(
              //   textAlign: TextAlign.center,
              //   'Восстановление пароля',
              //   style: TextStyle(
              //     fontFamily: 'Unbounded',
              //     fontSize: 20.sp,
              //     fontWeight: FontWeight.w500,
              //     color: ColorsConstants.primaryBrownColor,
              //   ),
              // ),
              // SizedBox(height: 36.h),
              // Text(
              //   textAlign: TextAlign.center,
              //   'Для восстановления пароля мы вышлем Вам SMS с проверочным кодом',
              //   style: TextStyle(
              //     fontFamily: 'Unbounded',
              //     fontSize: 16.sp,
              //     fontWeight: FontWeight.w400,
              //     color: ColorsConstants.primaryBrownColor,
              //   ),
              // ),
              // SizedBox(height: 48.h),
              // StatefulBuilder(
              //   builder: (context, setLocalState) {
              //     return PrimaryTextFormField(
              //       autoValidateMode: AutovalidateMode.onUnfocus,
              //       controller: _phoneController,
              //       labelText: 'Номер телефона',
              //       keyboardType: TextInputType.phone,
              //       inputFormatters: [phoneMaskFormatter],
              //       prefixIcon: const Icon(Icons.phone),
              //       validator: (value) {
              //         final digits = value!.replaceAll(RegExp(r'[^\d]'), '');
              //         if (digits.isEmpty || digits == '7') {
              //           return 'Введите номер телефона';
              //         }
              //         if (digits.length < 11) {
              //           return 'Номер должен содержать 11 цифр';
              //         }
              //         return null;
              //       },
              //       onTap: () {
              //         if (_isFirstInteraction) {
              //           _phoneController.text = '+7 ';
              //           _phoneController.selection = TextSelection.collapsed(
              //             offset: _phoneController.text.length,
              //           );
              //           setLocalState(() {
              //             _isFirstInteraction = false;
              //           });
              //         }
              //       },
              //     );
              //   },
              // ),
              // SizedBox(height: 30.h),
              // PrimaryButton(text: 'Выслать код', onPressed: () {}),
              // SizedBox(height: 60.h),
              Text(
                textAlign: TextAlign.center,
                'ФУНКЦИЯ В ДОРАБОТКЕ...',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstants.primaryBrownColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
