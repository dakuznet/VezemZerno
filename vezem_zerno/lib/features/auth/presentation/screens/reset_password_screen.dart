import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const _phoneMask = '+7 (###) ###-##-##';
  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final MaskTextInputFormatter _phoneMaskFormatter;

  final _formKey = GlobalKey<FormState>();
  bool _codeSent = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _codeController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneMaskFormatter = MaskTextInputFormatter(
      mask: _phoneMask,
      filter: {'#': RegExp(r'[0-9]')},
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Восстановление пароля',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetCodeSent) {
              PrimarySnackBar.show(
                context,
                text: 'Код отправлен на ваш телефон',
                borderColor: Colors.green,
              );
              setState(() => _codeSent = true);
            } else if (state is PasswordResetSuccess) {
              PrimarySnackBar.show(
                context,
                text: 'Пароль успешно изменен',
                borderColor: Colors.green,
              );
              context.router.pop();
            } else if (state is PasswordResetFailure) {
              PrimarySnackBar.show(
                context,
                text: 'Ошибка...',
                borderColor: Colors.red,
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    _codeSent
                        ? 'Введите код из SMS и новый пароль'
                        : 'Введите номер телефона для восстановления пароля',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (!_codeSent)
                    PrimaryTextFormField(
                      readOnly: false,
                      controller: _phoneController,
                      labelText: 'Номер телефона',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [_phoneMaskFormatter],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        final digits = value.replaceAll(RegExp(r'[^\d]'), '');
                        if (digits.length < 11) {
                          return 'Номер должен содержать 11 цифр';
                        }
                        return null;
                      },
                    ),
                  if (_codeSent) ...[
                    PrimaryTextFormField(
                      readOnly: false,
                      controller: _codeController,
                      labelText: 'Код из SMS',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите код';
                        }
                        if (value.length != 6) {
                          return 'Код должен содержать 6 цифр';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    PrimaryTextFormField(
                      readOnly: false,
                      controller: _passwordController,
                      labelText: 'Новый пароль',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите пароль';
                        }
                        if (value.length < 8) {
                          return 'Пароль должен быть не менее 8 символов';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    PrimaryTextFormField(
                      readOnly: false,
                      controller: _confirmPasswordController,
                      labelText: 'Подтвердите пароль',
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                  ],
                  SizedBox(height: 16.h),
                  PrimaryButton(
                    text: _codeSent ? 'Сменить пароль' : 'Отправить код',
                    isLoading: state is PasswordResetLoading,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (!_codeSent) {
                          context.read<AuthBloc>().add(
                            RequestPasswordResetEvent(
                              phone: _phoneController.text,
                            ),
                          );
                        } else {
                          context.read<AuthBloc>().add(
                            ConfirmPasswordResetEvent(
                              phone: _phoneController.text,
                              code: _codeController.text,
                              newPassword: _passwordController.text,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
