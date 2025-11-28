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
import 'package:vezem_zerno/features/auth/presentation/screens/widgets/privacy_check_box.dart';
import 'package:vezem_zerno/features/auth/presentation/screens/widgets/role_button.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static const _phoneMask = '+7 (###) ###-##-##';
  static const _phonePrefix = '+7 ';
  static const _phoneDigitCount = 11;
  static const _minPasswordLength = 8;

  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _organizationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFirstInteraction = true;
  bool _isPrivacyAccepted = false;

  String? _selectedRole;

  late final MaskTextInputFormatter _phoneMaskFormatter;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _organizationController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _initializePhoneMask();
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

  void _initializePhoneMask() {
    _phoneMaskFormatter = MaskTextInputFormatter(
      mask: _phoneMask,
      filter: {'#': RegExp(r'[0-9]')},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: _handleAuthStateChanges,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: ColorsConstants.backgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorsConstants.primaryBrownColor,
              iconSize: 24.r,
              onPressed: () =>
                  state is AuthLoading ? null : AutoRouter.of(context).back(),
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _registrationFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Регистрация',
                        style: TextStyle(
                          color: ColorsConstants.primaryBrownColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.auto,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        controller: _nameController,
                        labelText: 'Имя',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person),
                        validator: _validateName,
                      ),
                      SizedBox(height: 16.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.auto,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        controller: _surnameController,
                        labelText: 'Фамилия',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person),
                        validator: _validateSurname,
                      ),
                      SizedBox(height: 16.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.auto,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        controller: _organizationController,
                        labelText: 'Организация',
                        prefixIcon: const Icon(Icons.business),
                        keyboardType: TextInputType.text,
                        validator: _validateOrganization,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RoleButton(
                              role: 'Заказчик',
                              label: 'Заказчик',
                              onPressed: () =>
                                  setState(() => _selectedRole = 'Заказчик'),
                              selectedRole: _selectedRole,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: RoleButton(
                              role: 'Перевозчик',
                              label: 'Перевозчик',
                              onPressed: () =>
                                  setState(() => _selectedRole = 'Перевозчик'),
                              selectedRole: _selectedRole,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          return PrimaryTextFormField(
                            readOnly: false,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _phoneController,
                            labelText: 'Номер телефона',
                            keyboardType: TextInputType.phone,
                            inputFormatters: [_phoneMaskFormatter],
                            prefixIcon: const Icon(Icons.phone),
                            validator: _validatePhone,
                            onTap: () => _handlePhoneFieldTap(setLocalState),
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          return PrimaryTextFormField(
                            readOnly: false,
                            labelBehavior: FloatingLabelBehavior.never,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              onPressed: () =>
                                  _togglePasswordVisibility(setLocalState),
                            ),
                            validator: _validatePassword,
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      StatefulBuilder(
                        builder: (context, setLocalState) {
                          return PrimaryTextFormField(
                            readOnly: false,
                            labelBehavior: FloatingLabelBehavior.never,
                            controller: _confirmPasswordController,
                            labelText: 'Повторите пароль',
                            obscureText: _obscureConfirmPassword,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => _toggleConfirmPasswordVisibility(
                                setLocalState,
                              ),
                            ),
                            validator: _validateConfirmPassword,
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
                      SizedBox(height: 32.h),
                      PrimaryButton(
                        text: 'Зарегистрироваться',
                        onPressed: state is AuthLoading
                            ? null
                            : () => _handleRegistration(context),
                        isLoading: state is AuthLoading,
                      ),
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

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      PrimarySnackBar.show(
        context,
        text: "Ошибка регистрации\n${state.message}",
        borderColor: Colors.red,
      );
    } else if (state is AuthUserAlreadyExists) {
      PrimarySnackBar.show(
        context,
        text: state.message,
        borderColor: Colors.red,
      );
    } else if (state is NoInternetConnection) {
      PrimarySnackBar.show(
        context,
        text: "Проверьте подключение к интернету",
        borderColor: Colors.red,
      );
    } else if (state is VerificationCodeSent) {
      AutoRouter.of(context).push(
        PhoneVerificationRoute(
          phone: _phoneController.text,
          password: _passwordController.text,
          name: _nameController.text,
          surname: _surnameController.text,
          organization: _organizationController.text,
          role: _selectedRole!,
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите имя';
    }
    return null;
  }

  String? _validateSurname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите фамилию';
    }
    return null;
  }

  String? _validateOrganization(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите организацию';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите номер телефона';
    }

    final digits = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty || digits == '7') {
      return 'Введите номер телефона';
    }

    if (digits.length < _phoneDigitCount) {
      return 'Номер должен содержать $_phoneDigitCount цифр';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < _minPasswordLength) {
      return 'Пароль должен быть не менее $_minPasswordLength символов';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Пароли должны совпадать';
    }
    return _validatePassword(value);
  }

  void _handlePhoneFieldTap(void Function(void Function()) setLocalState) {
    if (_isFirstInteraction) {
      _phoneController.text = _phonePrefix;
      _phoneController.selection = TextSelection.collapsed(
        offset: _phoneController.text.length,
      );
      setLocalState(() {
        _isFirstInteraction = false;
      });
    }
  }

  void _togglePasswordVisibility(void Function(void Function()) setLocalState) {
    setLocalState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility(
    void Function(void Function()) setLocalState,
  ) {
    setLocalState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _handleRegistration(BuildContext context) {
    if (!_validateForm(context)) {
      return;
    }

    if (_registrationFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SendVerificationCodeEvent(
          phone: _normalizePhone(_phoneController.text),
        ),
      );
    }
  }

  bool _validateForm(BuildContext context) {
    if (_selectedRole == null) {
      PrimarySnackBar.show(
        context,
        text: 'Необходимо выбрать род деятельности: заказчик или перевозчик',
        borderColor: Colors.red,
      );
      return false;
    }

    if (!_isPrivacyAccepted) {
      PrimarySnackBar.show(
        context,
        text: 'Необходимо принять политику конфиденциальности',
        borderColor: Colors.red,
      );
      return false;
    }

    return true;
  }

  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.startsWith('8')) {
      return '7${digits.substring(1)}';
    } else if (digits.startsWith('7')) {
      return digits;
    } else {
      return '7$digits';
    }
  }
}
