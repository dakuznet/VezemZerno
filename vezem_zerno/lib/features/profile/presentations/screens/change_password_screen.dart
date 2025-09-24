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
import 'package:vezem_zerno/routes/router.dart';

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

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdatePasswordEvent(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        ),
      );
    }
  }

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
      appBar: AppBar(
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
          onPressed: () {
            AutoRouter.of(context).replace(const ProfileRoute());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is PasswordUpdated) {
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
                  backgroundColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0.r).r,
                    side: BorderSide(color: Colors.green, width: 2.0.w),
                  ),
                ),
              );
              AutoRouter.of(context).replace(const ProfileRoute());
            } else if (state is PasswordUpdateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ошибка изменения пароля\n${state.message}',
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
            }
          },
          builder: (context, state) {
            final isLoading = state is PasswordUpdating;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0).r,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
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
                              readOnly: false,
                              obscureText: true,
                              labelBehavior: FloatingLabelBehavior.never,
                              labelText: 'Введите старый пароль',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введите старый пароль';
                                }
                                return null;
                              },
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
                                fontFamily: 'Unbounded',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorsConstants.primaryBrownColor,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            PrimaryTextFormField(
                              controller: _newPasswordController,
                              readOnly: false,
                              obscureText: true,
                              labelBehavior: FloatingLabelBehavior.never,
                              labelText: 'Введите новый пароль',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Введите новый пароль';
                                }
                                if (value.length < 8) {
                                  return 'Пароль должен содержать минимум 8 символов';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            PrimaryTextFormField(
                              controller: _confirmPasswordController,
                              readOnly: false,
                              obscureText: true,
                              labelBehavior: FloatingLabelBehavior.never,
                              labelText: 'Подтвердите новый пароль',
                              validator: (value) {
                                if (value != _newPasswordController.text) {
                                  return 'Пароли не совпадают';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        PrimaryButton(
                          text: isLoading ? 'Загрузка...' : 'Сохранить',
                          onPressed: isLoading ? null : _updatePassword,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: const Color.fromARGB(55, 0, 0, 0),
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
          },
        ),
      ),
    );
  }
}
