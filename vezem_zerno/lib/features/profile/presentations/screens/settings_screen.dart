import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        centerTitle: true,
        title: Text(
          'Настройки',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
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
          padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 16.w).w,
          child: Center(child: PrimaryButton(text: 'Удалить профиль', onPressed: () {})),
        ),
      ),
    );
  }
}
