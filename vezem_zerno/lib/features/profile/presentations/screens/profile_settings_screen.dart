import 'dart:io' as io;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/routes/router.dart';

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

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isImageLoading = true;
      });

      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 100,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _profileImage = io.File(pickedFile.path);
          _isImageLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ошибка при выборе изображения',
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
    } finally {
      if (mounted && _profileImage == null) {
        setState(() {
          _isImageLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(
      SaveProfileEvent(
        name: _nameController.text,
        surname: _surnameController.text,
        organization: _organizationController.text,
        role: _selectedRole!,
        phone: _phoneController.text,
        imageFile: _profileImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Изменения сохранены',
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
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ошибка сохранения профиля\n${state.message}',
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
        if (state is ProfileLoaded) {
          _nameController.text = state.user.name ?? '';
          _surnameController.text = state.user.surname ?? '';
          _organizationController.text = state.user.organization ?? '';
          _selectedRole ??= state.user.role;
          _phoneController.text = state.user.phone;
          _currentImageUrl = state.user.profileImage;
        }
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
                fontWeight: FontWeight.w500,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                AutoRouter.of(context).replace(const ProfileRoute());
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w).w,
              child: Column(
                children: [
                  //Виджет изменения фотографии профиля
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        color:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                      ),
                      padding: EdgeInsets.all(8.w).w,
                      width: 360.w,
                      height: 120.h,
                      child: _isImageLoading
                          ? Center(child: CircularProgressIndicator())
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
                                      ? Icon(Icons.camera_alt, size: 30.w)
                                      : null,
                                ),
                                Text(
                                  'Изменить фото',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //Поля изменения данных профиля
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Имя:',
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstants.primaryBrownColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Имя',
                        controller: _nameController,
                        suffixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Фамилия:',
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstants.primaryBrownColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Фамилия',
                        controller: _surnameController,
                        suffixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Название организации:',
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstants.primaryBrownColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      PrimaryTextFormField(
                        readOnly: false,
                        labelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Название организации',
                        controller: _organizationController,
                        suffixIcon: Icon(
                          Icons.drive_file_rename_outline,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Телефон:',
                        style: TextStyle(
                          fontFamily: 'Unbounded',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstants.primaryBrownColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      PrimaryTextFormField(
                        readOnly: true,
                        labelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Телефон',
                        controller: _phoneController,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0.h).h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Род деятельности:',
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorsConstants.primaryBrownColor,
                          ),
                        ),
                        RadioGroup<String>(
                          groupValue: _selectedRole,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedRole = value;
                            });
                          },
                          child: Column(
                            children: [
                              RadioListTile<String>(
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return ColorsConstants
                                            .primaryBrownColor;
                                      }
                                      return null;
                                    }),
                                selected: _selectedRole == 'carrier',
                                title: Text(
                                  'Перевозчик',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                ),
                                value: 'carrier',
                              ),
                              RadioListTile<String>(
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return ColorsConstants
                                            .primaryBrownColor;
                                      }
                                      return null;
                                    }),
                                selected: _selectedRole == 'customer',
                                title: Text(
                                  'Заказчик',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                ),
                                value: 'customer',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Кнопка сохранить изменения
                  SizedBox(height: 16.h),
                  PrimaryButton(text: 'Сохранить', onPressed: _saveProfile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
