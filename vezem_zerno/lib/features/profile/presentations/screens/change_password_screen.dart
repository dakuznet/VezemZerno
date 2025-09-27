import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is PasswordUpdated) {
              _showPasswordUpdatedSuccess(context);
              _navigateBackToProfile(context);
            } else if (state is PasswordUpdateError) {
              _showPasswordUpdateError(context, state.message);
            }
          },
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      centerTitle: true,
      title: Text(
        'Изменение пароля',
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: ColorsConstants.primaryBrownColor,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: ColorsConstants.primaryBrownColor,
        onPressed: () => AutoRouter.of(context).pop(),
      ),
    );
  }

  void _showPasswordUpdatedSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Пароль успешно изменён',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: Colors.green, width: 2.w),
        ),
      ),
    );
  }

  void _showPasswordUpdateError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ошибка изменения пароля\n$message',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(color: Colors.red, width: 2.w),
        ),
      ),
    );
  }

  void _navigateBackToProfile(BuildContext context) {
    AutoRouter.of(context).pop();
  }

  Widget _buildContent(ProfileState state) {
    final isLoading = state is PasswordUpdating;

    return Stack(
      children: [
        _buildForm(isLoading),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsConstants.primaryBrownColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOldPasswordField(),
            SizedBox(height: 32.h),
            _buildNewPasswordFields(),
            SizedBox(height: 24.h),
            _buildSaveButton(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildOldPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Старый пароль:',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 8.h),
        PrimaryTextFormField(
          controller: _oldPasswordController,
          obscureText: true,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Введите старый пароль',
          validator: _validateOldPassword,
          readOnly: false,
        ),
      ],
    );
  }

  Widget _buildNewPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Новый пароль:',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 8.h),
        PrimaryTextFormField(
          readOnly: false,
          controller: _newPasswordController,
          obscureText: true,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Введите новый пароль',
          validator: _validateNewPassword,
        ),
        SizedBox(height: 16.h),
        PrimaryTextFormField(
          readOnly: false,
          controller: _confirmPasswordController,
          obscureText: true,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Подтвердите новый пароль',
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: PrimaryButton(
        text: isLoading ? 'Изменение...' : 'Сохранить',
        onPressed: isLoading ? null : _handleUpdatePassword,
      ),
    );
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите старый пароль';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите новый пароль';
    }
    if (value.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  void _handleUpdatePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(
        UpdatePasswordEvent(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }
}
