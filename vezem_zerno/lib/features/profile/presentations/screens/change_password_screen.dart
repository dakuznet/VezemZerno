// change_password_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
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
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is PasswordUpdated) {
          PrimarySnackBar.show(
            context,
            text: 'Пароль успешно изменён',
            borderColor: Colors.green,
          );

          context.read<ProfileBloc>().add(LoadProfileEvent());
          AutoRouter.of(context).back();
        } else if (state is PasswordUpdateError) {
          PrimarySnackBar.show(
            context,
            text: 'Произошла ошибка...\nПроверьте соединение с интернетом',
            borderColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            centerTitle: true,
            title: Text(
              'Изменение пароля',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(Icons.arrow_back),
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Старый пароль:',
                          style: TextStyle(
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
                          readOnly: state is PasswordUpdating,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Новый пароль:',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorsConstants.primaryBrownColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        PrimaryTextFormField(
                          readOnly: state is PasswordUpdating,
                          controller: _newPasswordController,
                          obscureText: true,
                          labelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Введите новый пароль',
                          validator: _validateNewPassword,
                        ),
                        SizedBox(height: 16.h),
                        PrimaryTextFormField(
                          readOnly: state is PasswordUpdating,
                          controller: _confirmPasswordController,
                          obscureText: true,
                          labelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Подтвердите новый пароль',
                          validator: _validateConfirmPassword,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    PrimaryButton(
                      text: 'Сохранить',
                      onPressed: _handleUpdatePassword,
                      isLoading: state is PasswordUpdating,
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
