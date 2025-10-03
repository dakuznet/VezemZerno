import 'dart:io' as io;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';

@RoutePage()
class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  io.File? _profileImage;
  String? _currentImageUrl;
  String? _selectedRole;
  bool _isImageLoading = false;
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
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
        PrimarySnackBar.show(
          context: context,
          text: 'Ошибка при выборе изображения',
          borderColor: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImageLoading = false;
        });
      }
    }
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(
      SaveProfileEvent(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        organization: _organizationController.text.trim(),
        role: _selectedRole!,
        phone: _phoneController.text.trim(),
        imageFile: _profileImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && !_isDataInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _nameController.text = state.user.name ?? '';
                _surnameController.text = state.user.surname ?? '';
                _organizationController.text = state.user.organization ?? '';
                _selectedRole = state.user.role;
                _phoneController.text = state.user.phone;
                _currentImageUrl = state.user.profileImage;
                _isDataInitialized = true;
              });
            }
          });
        }

        if (state is ProfileSaved) {
          PrimarySnackBar.show(
            context: context,
            text: 'Изменения сохранены',
            borderColor: Colors.green,
          );
        }

        if (state is ProfileError) {
          PrimarySnackBar.show(
            context: context,
            text: 'Ошибка сохранения профиля\n${state.message}',
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
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Управление профилем',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => state is ProfileSaving ? null : AutoRouter.of(context).back(),
              icon: const Icon(Icons.arrow_back),
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                      ),
                      padding: EdgeInsets.all(8.w),
                      width: 360.w,
                      height: 120.h,
                      child: _isImageLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 4.w,
                                backgroundColor: ColorsConstants
                                    .primaryTextFormFieldBackgorundColor,
                                color: ColorsConstants.primaryBrownColor,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      ColorsConstants.backgroundColor,
                                  foregroundColor:
                                      ColorsConstants.primaryBrownColor,
                                  radius: 50.r,
                                  backgroundImage: _profileImage != null
                                      ? FileImage(_profileImage!)
                                      : (_currentImageUrl != null &&
                                                _currentImageUrl!.isNotEmpty
                                            ? NetworkImage(_currentImageUrl!)
                                            : null),
                                  child:
                                      _profileImage == null &&
                                          (_currentImageUrl == null ||
                                              _currentImageUrl!.isEmpty)
                                      ? Icon(Icons.camera_alt, size: 24.w)
                                      : null,
                                ),
                                Text(
                                  'Изменить фото',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  _buildNameField(),
                  SizedBox(height: 16.h),
                  _buildSurnameField(),
                  SizedBox(height: 16.h),
                  _buildOrganizationField(),
                  SizedBox(height: 16.h),
                  _buildPhoneField(),
                  SizedBox(height: 16.h),
                  _buildRoleSelection(),
                  SizedBox(height: 16.h),

                  PrimaryButton(
                    text: 'Сохранить',
                    onPressed: state is ProfileSaving ? null : _saveProfile,
                    isLoading: state is ProfileSaving,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Имя',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: false,
          controller: _nameController,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Имя',
          suffixIcon: Icon(Icons.drive_file_rename_outline, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildSurnameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Фамилия',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: false,
          controller: _surnameController,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Фамилия',
          suffixIcon: Icon(Icons.drive_file_rename_outline, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildOrganizationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Название организации',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: false,
          controller: _organizationController,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Название организации',
          suffixIcon: Icon(Icons.drive_file_rename_outline, size: 24.sp),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Телефон',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          controller: _phoneController,
          readOnly: true,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Телефон',
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Род деятельности',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 8.h),
        RadioGroup<String?>(
          groupValue: _selectedRole,
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue;
            });
          },
          child: Column(
            children: [
              RadioListTile<String?>(
                fillColor: WidgetStateProperty.all(
                  ColorsConstants.primaryBrownColor,
                ),
                value: 'carrier',
                title: Text(
                  'Перевозчик',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ),
              RadioListTile<String?>(
                fillColor: WidgetStateProperty.all(
                  ColorsConstants.primaryBrownColor,
                ),
                value: 'customer',
                title: Text(
                  'Заказчик',
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
