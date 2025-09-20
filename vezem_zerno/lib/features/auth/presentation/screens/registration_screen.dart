import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/auth/presentation/widgets/privacy_check_box.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _registrationFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFirstInteraction = true;
  bool _isPrivacyAccepted = false;

  String? _selectedRole;

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
    _nameController.dispose();
    _surnameController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 8) {
      return 'Пароль должен быть не менее 8 символов';
    }
    return null;
  }

  void _handleRegistration(BuildContext context) {
    if (_registrationFormKey.currentState?.validate() ?? false) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Выберите роль: заказчик или перевозчик',
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
        return;
      }

      if (!_isPrivacyAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Примите политику конфиденциальности',
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
        return;
      }

      context.read<AuthBloc>().add(
        SendVerificationCodeEvent(
          phone: _phoneController.text,
          name: _nameController.text,
          surname: _surnameController.text,
          organization: _organizationController.text,
          role: _selectedRole!,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ошибка регистрации',
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0.r).r,
                side: BorderSide(color: Colors.red, width: 2.0.w),
              ),
            ),
          );
        } else if (state is AuthUserAlreadyExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0.r).r,
                side: BorderSide(color: Colors.red, width: 2.0.w),
              ),
            ),
          );
        } else if (state is VerificationCodeSent) {
          AutoRouter.of(context).push(
            PhoneVerificationRoute(
              phone: _phoneController.text,
              password: _passwordController.text,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
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
              child: Padding(
                padding: EdgeInsets.only(left: 24.0.w, right: 24.0.w).r,
                child: Form(
                  key: _registrationFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Регистрация',
                        style: TextStyle(
                          color: ColorsConstants.primaryBrownColor,
                          fontFamily: 'Unbounded',
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.auto,
                        autoValidateMode: AutovalidateMode.onUnfocus,
                        controller: _nameController,
                        labelText: 'Имя',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите Ваше имя';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.auto,
                        autoValidateMode: AutovalidateMode.onUnfocus,
                        controller: _surnameController,
                        labelText: 'Фамилия',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите Вашу фамилию';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.auto,
                        autoValidateMode: AutovalidateMode.onUnfocus,
                        controller: _organizationController,
                        labelText: 'Организация',
                        prefixIcon: const Icon(Icons.business),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите Вашу организацию';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 12.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    setState(() => _selectedRole = 'customer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedRole == 'customer'
                                      ? ColorsConstants
                                            .primaryButtonBackgroundColor
                                      : ColorsConstants
                                            .notSelectedTextButtonColor,
                                  foregroundColor: _selectedRole == 'customer'
                                      ? ColorsConstants
                                            .notSelectedTextButtonColor
                                      : ColorsConstants
                                            .primaryButtonBackgroundColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                  ).r,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.r).r,
                                    side: BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  'Заказчик',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontSize: 14.sp,
                                    color: _selectedRole == 'customer'
                                        ? ColorsConstants.primaryBrownColor
                                        : ColorsConstants
                                              .primaryBrownColorWithOpacity,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 24.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    setState(() => _selectedRole = 'carrier'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedRole == 'carrier'
                                      ? ColorsConstants
                                            .primaryButtonBackgroundColor
                                      : ColorsConstants
                                            .notSelectedTextButtonColor,
                                  foregroundColor: _selectedRole == 'carrier'
                                      ? ColorsConstants
                                            .notSelectedTextButtonColor
                                      : ColorsConstants
                                            .primaryButtonBackgroundColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                  ).r,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.r).r,
                                    side: BorderSide.none,
                                  ),
                                ),
                                child: Text(
                                  'Перевозчик',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontSize: 14.sp,
                                    color: _selectedRole == 'carrier'
                                        ? ColorsConstants.primaryBrownColor
                                        : ColorsConstants
                                              .primaryBrownColorWithOpacity,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          return PrimaryTextFormField(
                            readOnly: false,
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
                      SizedBox(height: 12.h),
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          return PrimaryTextFormField(
                            readOnly: false,
                            labelBehavior: FloatingLabelBehavior.never,
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
                              onPressed: () => setLocalState(() {
                                _obscurePassword = !_obscurePassword;
                              }),
                            ),
                            validator: _validatePassword,
                          );
                        },
                      ),
                      SizedBox(height: 12.h),
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          return PrimaryTextFormField(
                            readOnly: false,
                            labelBehavior: FloatingLabelBehavior.never,
                            controller: _confirmPasswordController,
                            labelText: 'Повторите пароль',
                            obscureText: _obscureConfirmPassword,
                            autoValidateMode: AutovalidateMode.onUnfocus,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => setLocalState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              }),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Пароли должны совпадать';
                              }
                              return _validatePassword(value);
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      PrivacyCheckbox(
                        initialValue: _isPrivacyAccepted,
                        onChanged: (value) =>
                            setState(() => _isPrivacyAccepted = value),
                        errorText: _isPrivacyAccepted
                            ? null
                            : 'Необходимо принять политику конфиденциальности',
                      ),
                      SizedBox(height: 16.h),
                      PrimaryButton(
                        text: state is AuthLoading
                            ? 'Загрузка...'
                            : 'Зарегистрироваться',
                        onPressed: state is AuthLoading
                            ? null
                            : () => _handleRegistration(context),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
