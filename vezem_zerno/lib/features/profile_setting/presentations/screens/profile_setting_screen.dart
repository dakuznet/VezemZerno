import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/routes/router.dart';

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
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        title: Text(
          'Управление профилем',
          style: TextStyle(fontSize: 20.sp),
        ),
        leading: IconButton(
        onPressed:() {AutoRouter.of(context).replace(const ProfileRoute());}, 
        icon: Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: Container(
        color: ColorsConstants.backgroundColor,
        child: SingleChildScrollView(     
          padding: EdgeInsets.all(16.w),
          child: Column(     
            children: [
              // Загрузка фото
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/placeholder.png') as ImageProvider,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15.r,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.camera_alt, size: 15.w),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),

              Text(
                'Загрузить фото',
                style: TextStyle(fontSize: 14.sp),
              ),

              SizedBox(height: 16.h),
              
              // Поля ввода
              _buildTextField('Имя пользователя', _nameController),
              _buildTextField('Фамилия пользователя', _surnameController),
              _buildTextField('Организация пользователя', _organizationController),
              _buildNumberField('Номер телефона', _phoneController),
              _buildTextField('Род деятельности пользователя', _activityController),
              
              // Смена пароля
              SizedBox(height: 16.h),

              Align(
                alignment: Alignment.center,
                child: Text(
                  'Смена пароля',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 16.h),
            
              _buildPasswordField('Новый пароль', _newPasswordController),
              _buildPasswordField('Повторите пароль', _repeatPasswordController),
        
              // Кнопка Сохранить
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: () {
                  // Логика сохранения
                },    
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstants.primaryButtonBackgroundColor,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text('Сохранить', style: TextStyle(fontSize: 18.sp,color: ColorsConstants.primaryBrownColor),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return Padding( 
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true, 
          fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor, 
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorsConstants.primaryBrownColor, width: 1.0.w),
          ),
          
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildNumberField (String hintText,TextEditingController controller) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          filled: true, 
          fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor, 
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorsConstants.primaryBrownColor, width: 1.0.w),
          ),
          
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hintText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          filled: true, 
          fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor, 
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorsConstants.primaryBrownColor, width: 1.0.w),
          ),
          
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}