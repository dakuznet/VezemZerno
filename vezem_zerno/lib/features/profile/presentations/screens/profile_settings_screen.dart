// profile_settings_screen.dart
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
  final TextEditingController _roleController = TextEditingController();

  io.File? _profileImage;
  String? _currentImageUrl;
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
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    context.read<ProfileBloc>();

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
          context,
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
        role: _roleController.text,
        phone: _phoneController.text.trim(),
        imageFile: _profileImage,
      ),
    );
  }

  bool _shouldBlockInteractions(ProfileState state) {
    return state is NoInternetConnection ||
        state is ProfileSaving ||
        state is ProfileLoading;
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
                _roleController.text = state.user.role == 'carrier'
                    ? 'Перевозчик'
                    : 'Заказчик';
                _phoneController.text = state.user.phone;
                _currentImageUrl = state.user.profileImage;
                _isDataInitialized = true;
              });
            }
          });
        }

        if (state is ProfileError) {
          PrimarySnackBar.show(
            context,
            text: 'Ошибка сохранения профиля\n${state.message}',
            borderColor: Colors.red,
          );
        } else if (state is ProfileSaved) {
          PrimarySnackBar.show(
            context,
            text: 'Профиль успешно сохранён',
            borderColor: Colors.green,
          );
        }
      },
      builder: (context, state) {
        final shouldBlockInteractions = _shouldBlockInteractions(state);
        final hasNoInternet = state is NoInternetConnection;

        return Scaffold(
          appBar: _buildAppBar(state, shouldBlockInteractions),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: _buildContent(state, shouldBlockInteractions, hasNoInternet),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    ProfileState state,
    bool shouldBlockInteractions,
  ) {
    return AppBar(
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
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
        onPressed: shouldBlockInteractions
            ? null
            : () => AutoRouter.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
        color: shouldBlockInteractions
            ? ColorsConstants.primaryBrownColorWithOpacity
            : ColorsConstants.primaryBrownColor,
      ),
    );
  }

  Widget _buildContent(
    ProfileState state,
    bool shouldBlockInteractions,
    bool hasNoInternet,
  ) {
    if (hasNoInternet) {
      return _buildNoInternetContent();
    }

    return AbsorbPointer(
      absorbing: shouldBlockInteractions,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildImageSection(state),
            SizedBox(height: 16.h),
            _buildNameField(state),
            SizedBox(height: 16.h),
            _buildSurnameField(state),
            SizedBox(height: 16.h),
            _buildOrganizationField(state),
            SizedBox(height: 16.h),
            _buildPhoneField(state),
            SizedBox(height: 16.h),
            _buildRoleField(state),
            SizedBox(height: 16.h),
            _buildSaveButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildNoInternetContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 4.w,
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            color: ColorsConstants.primaryBrownColor,
          ),
          SizedBox(height: 24.h),
          Text(
            'Загрузка...',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(ProfileState state) {
    final isSaving = state is ProfileSaving;

    return GestureDetector(
      onTap: isSaving ? null : _pickImage,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        ),
        padding: EdgeInsets.all(8.w),
        width: 360.w,
        height: 120.h,
        child: _isImageLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.w,
                  backgroundColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  color: ColorsConstants.primaryBrownColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: ColorsConstants.backgroundColor,
                    foregroundColor: ColorsConstants.primaryBrownColor,
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isSaving
                          ? ColorsConstants.primaryBrownColorWithOpacity
                          : ColorsConstants.primaryBrownColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildNameField(ProfileState state) {
    final isSaving = state is ProfileSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Имя',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: isSaving,
          controller: _nameController,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Имя',
          suffixIcon: Icon(
            Icons.drive_file_rename_outline,
            size: 24.sp,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSurnameField(ProfileState state) {
    final isSaving = state is ProfileSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Фамилия',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: isSaving,
          controller: _surnameController,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Фамилия',
          suffixIcon: Icon(
            Icons.drive_file_rename_outline,
            size: 24.sp,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizationField(ProfileState state) {
    final isSaving = state is ProfileSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Название организации',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          readOnly: isSaving,
          controller: _organizationController,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Название организации',
          suffixIcon: Icon(
            Icons.drive_file_rename_outline,
            size: 24.sp,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(ProfileState state) {
    final isSaving = state is ProfileSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Телефон',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
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

  Widget _buildRoleField(ProfileState state) {
    final isSaving = state is ProfileSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Вид деятельности',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isSaving
                ? ColorsConstants.primaryBrownColorWithOpacity
                : ColorsConstants.primaryBrownColor,
          ),
        ),
        SizedBox(height: 4.h),
        PrimaryTextFormField(
          controller: _roleController,
          readOnly: true,
          labelBehavior: FloatingLabelBehavior.never,
          labelText: 'Вид деятельности',
        ),
      ],
    );
  }

  Widget _buildSaveButton(ProfileState state) {
    final isSaving = state is ProfileSaving;
    final hasNoInternet = state is NoInternetConnection;

    return PrimaryButton(
      text: 'Сохранить',
      onPressed: (isSaving || hasNoInternet) ? null : _saveProfile,
      isLoading: isSaving,
    );
  }
}
