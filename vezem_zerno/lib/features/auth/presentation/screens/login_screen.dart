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
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _phoneMask = '+7 (###) ###-##-##';
  static const _phonePrefix = '+7 ';
  static const _phoneDigitCount = 11;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFirstInteraction = true;

  late final MaskTextInputFormatter _phoneMaskFormatter;

  @override
  void initState() {
    super.initState();
    _initializePhoneMask();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
            backgroundColor: ColorsConstants.backgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorsConstants.primaryBrownColor,
              iconSize: 24.sp,
              onPressed: () =>
                  context.router.replaceAll([const WelcomeRoute()]),
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Text(
                        'Вход',
                        style: TextStyle(
                          color: ColorsConstants.primaryBrownColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    StatefulBuilder(
                      builder: (context, setLocalState) {
                        return PrimaryTextFormField(
                          readOnly: false,
                          labelBehavior: FloatingLabelBehavior.auto,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
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
                          labelBehavior: FloatingLabelBehavior.auto,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
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
                    TextButton(
                      onPressed: () => state is AuthLoading
                          ? null
                          : AutoRouter.of(
                              context,
                            ).push(const ResetPasswordRoute()),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorsConstants.primaryBrownColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        "Забыли пароль?",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstants.primaryBrownColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    PrimaryButton(
                      text: 'Войти',
                      isLoading: state is AuthLoading,
                      onPressed: () => _handleLogin(context),
                    ),
                  ],
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
        text: state.message,
        borderColor: Colors.red,
      );
    } else if (state is LoginSuccess) {
      AutoRouter.of(context).replaceAll([const MainRoute()]);
    } else if (state is NoInternetConnection) {
      PrimarySnackBar.show(
        context,
        text: 'Проверьте соединение с интернетом',
        borderColor: Colors.red,
      );
    }
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
    return null;
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

  void _handleLogin(BuildContext context) {
    if (_loginFormKey.currentState?.validate() ?? false) {
      final phone = _normalizePhone(_phoneController.text);
      final password = _passwordController.text;

      context.read<AuthBloc>().add(
        LoginEvent(phone: phone, password: password),
      );
    }
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
