import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
const SettingScreen({super.key});

@override
State<SettingScreen> createState() => _SettingScreenState(); 
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        centerTitle: true,
        title:  Text('Настройки'),
        leading: IconButton(
        onPressed:() {AutoRouter.of(context).replace(const ProfileRoute());}, 
        icon: Icon(Icons.arrow_back)),
      ),
      body: Container(
        color: ColorsConstants.backgroundColor,
        child: Column(
          children: [
            SizedBox(height: 50.h),
             Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsConstants.primaryButtonBackgroundColor,
                    foregroundColor: ColorsConstants.primaryBrownColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Удаление профиля'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


