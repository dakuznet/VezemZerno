import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
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
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ошибка входа....\n${state.message}',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 14.sp,
                  color: ColorsConstants.primaryBrownColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor:
                  ColorsConstants.primaryTextFormFieldBackgorundColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is LoginSuccess) {
          AutoRouter.of(context).replaceAll([const HomeRoute()]);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsConstants.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: ColorsConstants.primaryBrownColor,
            iconSize: 30.r,
            onPressed: () =>
                AutoRouter.of(context).replaceAll([const WelcomeRoute()]),
          ),
        ),
        backgroundColor: ColorsConstants.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.0.w,
              right: 24.0.w,
              top: 144.0.h,
            ).r,
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  Text(
                    'Вход',
                    style: TextStyle(
                      color: ColorsConstants.primaryBrownColor,
                      fontFamily: 'Unbounded',
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  StatefulBuilder(
                    builder: (context, setLocalState) {
                      return PrimaryTextFormField(
                        autoValidateMode: AutovalidateMode.onUnfocus,
                        controller: _phoneController,
                        labelText: 'Номер телефона',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMaskFormatter],
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          final digits = value!.replaceAll(
                            RegExp(r'[^\d]'),
                            '',
                          );
                          if (digits.isEmpty || digits == '7') {
                            return 'Введите номер телефона';
                          }
                          if (digits.length < 11) {
                            return 'Номер должен содержать 11 цифр';
                          }
                          return null;
                        },
                        onTap: () {
                          if (_isFirstInteraction) {
                            _phoneController.text = '+7 ';
                            _phoneController.selection =
                                TextSelection.collapsed(
                                  offset: _phoneController.text.length,
                                );
                            setLocalState(() {
                              _isFirstInteraction = false;
                            });
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  StatefulBuilder(
                    builder: (context, setLocalState) {
                      return PrimaryTextFormField(
                        autoValidateMode: AutovalidateMode.onUnfocus,
                        controller: _passwordController,
                        labelText: 'Пароль',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setLocalState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите пароль';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     style: ButtonStyle(
                  //       splashFactory: NoSplash.splashFactory,
                  //       overlayColor: WidgetStateProperty.all(
                  //         Colors.transparent,
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       AutoRouter.of(
                  //         context,
                  //       ).push(const PasswordRecoveryRoute());
                  //     },
                  //     child: Text(
                  //       "Забыли пароль?",
                  //       style: TextStyle(
                  //         fontFamily: 'Unbounded',
                  //         fontSize: 14.sp,
                  //         fontWeight: FontWeight.w500,
                  //         color: ColorsConstants.primaryBrownColor,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 48.h),
                  PrimaryButton(
                    text: 'Войти',
                    onPressed: () {
                      if (_loginFormKey.currentState?.validate() ?? false) {
                        final phone = _normalizePhone(_phoneController.text);
                        final password = _passwordController.text;
                        context.read<AuthBloc>().add(
                          LoginEvent(phone: phone, password: password),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    return digits.startsWith('8')
        ? '7${digits.substring(1)}'
        : digits.startsWith('7')
        ? digits
        : '7$digits';
  }
}
