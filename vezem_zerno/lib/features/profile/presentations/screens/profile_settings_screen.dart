// profile_settings_screen.dart
import 'dart:io' as io;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_settings_image_section.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_settings_text_field_section.dart';

@RoutePage()
class ProfileSettingScreen extends StatefulWidget {
  final UserEntity? user;

  const ProfileSettingScreen({super.key, required this.user});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _organizationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _roleController;

  io.File? _profileImage;
  bool _isImageLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _surnameController = TextEditingController(
      text: widget.user?.surname ?? '',
    );
    _organizationController = TextEditingController(
      text: widget.user?.organization ?? '',
    );
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _roleController = TextEditingController(text: widget.user?.role ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isImageLoading) return;

    try {
      setState(() {
        _isImageLoading = true;
      });

      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600.w,
        maxHeight: 600.h,
        imageQuality: 100,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _profileImage = io.File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Ошибка при выборе изображения');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    PrimarySnackBar.show(context, text: message, borderColor: Colors.red);
  }

  void _saveProfile() {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is LoginSuccess ? authState.user.id : null;
    context.read<ProfileBloc>().add(
      SaveProfileEvent(
        userId: userId!,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        organization: _organizationController.text.trim(),
        role: _roleController.text,
        phone: _phoneController.text.trim(),
        imageFile: _profileImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          PrimarySnackBar.show(
            context,
            text: 'Произошла ошибка...\nПроверьте соединение с интернетом',
            borderColor: Colors.red,
          );
        }
        if (state is ProfileSaved) {
          context.router.pop();
          PrimarySnackBar.show(
            context,
            text: 'Профиль сохранён',
            borderColor: Colors.green,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Управление профилем',
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
          body: Padding(
            padding: EdgeInsetsGeometry.all(16.w),
            child: CustomScrollView(
              slivers: [
                if (state is ProfileLoading)
                  SliverToBoxAdapter(child: const PrimaryLoadingIndicator())
                else if (state is ProfileError)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: ColorsConstants
                                    .primaryTextFormFieldBackgorundColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                size: 40.sp,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Возникла ошибка при загрузке данных...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            TextButton(
                              onPressed: () => context.read<ProfileBloc>().add(
                                LoadProfileEvent(),
                              ),
                              child: Text(
                                'Повторить',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsConstants.primaryBrownColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ProfileSettingsImageSection(
                        isSaving: state is ProfileSaving,
                        isLoading: _isImageLoading,
                        onTap: _pickImage,
                        currentImageUrl: widget.user?.profileImage ?? '',
                        profileImage: _profileImage,
                      ),
                      SizedBox(height: 16.h),
                      ProfileSettingsTextFieldSection(
                        label: 'Имя',
                        controller: _nameController,
                        isSaving: state is ProfileSaving,
                      ),
                      SizedBox(height: 16.h),
                      ProfileSettingsTextFieldSection(
                        label: 'Фамилия',
                        controller: _surnameController,
                        isSaving: state is ProfileSaving,
                      ),
                      SizedBox(height: 16.h),
                      ProfileSettingsTextFieldSection(
                        label: 'Организация',
                        controller: _organizationController,
                        isSaving: state is ProfileSaving,
                      ),
                      SizedBox(height: 16.h),
                      ProfileSettingsTextFieldSection(
                        label: 'Телефон',
                        controller: _phoneController,
                        isSaving: state is ProfileSaving,
                        readOnly: true,
                      ),
                      SizedBox(height: 16.h),
                      ProfileSettingsTextFieldSection(
                        label: 'Вид деятельности',
                        controller: _roleController,
                        isSaving: state is ProfileSaving,
                        readOnly: true,
                      ),
                      SizedBox(height: 32.h),
                      PrimaryButton(
                        text: 'Сохранить',
                        isLoading: state is ProfileSaving,
                        onPressed: _saveProfile,
                      ),
                    ]),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
