import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class PhoneVerificationScreen extends StatefulWidget {
  final String phone;
  final String password;

  const PhoneVerificationScreen({
    super.key,
    @PathParam('phone') required this.phone,
    @PathParam('password') required this.password,
  });

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  static const _codeLength = 6;

  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: _handleAuthStateChanges,
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsConstants.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: ColorsConstants.primaryBrownColor,
        iconSize: 24.r,
        onPressed: () => _navigateBack(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.r),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildHeaderText(),
            SizedBox(height: 32.h),
            _buildPinCodeField(state),
            SizedBox(height: 24.h),
            _buildConfirmButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Text(
          'Мы отправили SMS с кодом подтверждения на номер:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          widget.phone,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeField(AuthState state) {
    return Column(
      children: [
        PinCodeTextField(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          appContext: context,
          length: _codeLength,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          cursorColor: ColorsConstants.primaryBrownColor,
          pinTheme: _buildPinTheme(),
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          controller: _codeController,
          validator: (value) => _validateCode(value),
          onChanged: (value) => _handleCodeChange(value, state),
          onCompleted: (value) => _handleCodeCompletion(value, context),
        ),
        if (state is AuthFailure && _codeController.text.isNotEmpty)
          _buildErrorText(state),
      ],
    );
  }

  PinTheme _buildPinTheme() {
    return PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(8.r),
      fieldHeight: 60.h,
      fieldWidth: 40.w,
      selectedFillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      selectedColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      inactiveFillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      inactiveColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      activeFillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      activeColor: ColorsConstants.primaryBrownColor,
    );
  }

  Widget _buildErrorText(AuthFailure state) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        state.message,
        style: TextStyle(
          color: Colors.red,
          fontSize: 14.sp,
          fontFamily: 'Unbounded',
        ),
      ),
    );
  }

  Widget _buildConfirmButton(AuthState state) {
    if (state is AuthLoading) {
      return _buildLoadingIndicator();
    }

    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Подтвердить',
        onPressed: () => _handleVerification(context),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return CircularProgressIndicator(
      strokeWidth: 5.w,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      color: ColorsConstants.primaryBrownColor,
    );
  }

  void _handleAuthStateChanges(BuildContext context, AuthState state) {
    if (state is AuthFailure) {
      PrimarySnackBar.show(
        context: context,
        text: 'Ошибка регистрации\n${state.message}',
        borderColor: Colors.red,
      );
    } else if (state is NoInternetConnection) {
      PrimarySnackBar.show(
        context: context,
        text: 'Ошибка...\nПроверьте подключение к интернету',
        borderColor: Colors.red,
      );
    } else if (state is VerificationCodeSuccess) {
      _handleVerificationSuccess(context);
    }
  }

  void _handleVerificationSuccess(BuildContext context) {
    PrimarySnackBar.show(
      context: context,
      text:
          'Регистрация выполнена успешно!\nЧтобы продолжить войдите в аккаунт',
      borderColor: Colors.green,
    );

    _navigateToLogin(context);
  }

  String? _validateCode(String? value) {
    if (value == null || value.length != _codeLength) {
      return 'Введите 6-значный код';
    }
    return null;
  }

  void _handleCodeChange(String value, AuthState state) {}

  void _handleCodeCompletion(String value, BuildContext context) {
    _handleVerification(context);
  }

  void _handleVerification(BuildContext context) {
    if (_codeController.text.length != _codeLength) {
      PrimarySnackBar.show(context: context, text: 'Введите 6-значный код');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        VerifyCodeEvent(phone: widget.phone, code: _codeController.text),
      );
    }
  }

  void _navigateBack(BuildContext context) {
    context.router.back();
  }

  void _navigateToLogin(BuildContext context) {
    context.router.replaceAll([const LoginRoute()]);
  }
}
