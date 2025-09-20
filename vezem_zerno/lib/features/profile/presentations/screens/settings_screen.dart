import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDeleting = false;

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
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is AccountDeleting) {
              setState(() {
                _isDeleting = true;
              });
            } else if (state is AccountDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Аккаунт был успешно удален',
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
                    borderRadius: BorderRadius.circular(
                      8.0.r,
                    ).r, // Радиус скругления
                    side: BorderSide(
                      color: Colors.green, // Зеленая граница
                      width: 2.0.w, // Толщина границы
                    ),
                  ),
                ),
              );
              context.read<AuthBloc>().add(LogoutEvent());
              AutoRouter.of(context).replace(const WelcomeRoute());
            } else if (state is AccountDeleteError) {
              setState(() {
                _isDeleting = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Ошибка удаления профиля',
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
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: 50.h,
                  horizontal: 16.w,
                ).w,
                child: Center(
                  child: PrimaryButton(
                    text: 'Удалить профиль',
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                ),
              ),
              if (_isDeleting)
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
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return AlertDialog(
              scrollable: false,
              actionsAlignment: MainAxisAlignment.spaceBetween,
              backgroundColor: ColorsConstants.backgroundColor,
              title: Text(
                'Удалить аккаунт',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstants.primaryBrownColor,
                ),
              ),
              content: Text(
                'Вы уверены, что хотите удалить свой аккаунт? Это действие невозможно отменить. Все ваши данные будут безвозвратно удалены.',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(195, 66, 44, 26),
                ),
              ),
              actions: <Widget>[
                if (state is! AccountDeleting)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      elevation: 4.r,
                      backgroundColor:
                          ColorsConstants.primaryButtonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                        side: BorderSide(
                          color: ColorsConstants.primaryButtonBorderColor,
                          width: 3.w,
                        ),
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: TextStyle(
                        color: ColorsConstants.primaryBrownColor,
                        fontSize: 14.sp,
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: (state is AccountDeleting)
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(DeleteAccountEvent());
                        },
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    elevation: 4.r,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.r),
                    ),
                  ),
                  child: (state is AccountDeleting)
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            backgroundColor: ColorsConstants
                                .primaryTextFormFieldBackgorundColor,
                            color: ColorsConstants.primaryBrownColor,
                          ),
                        )
                      : Text(
                          'Удалить',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
