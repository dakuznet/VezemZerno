import 'package:auto_route/auto_route.dart' ;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/bottom_navigation_bar.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';


@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

@override
State<ProfileScreen> createState() => _ProfileScreenState(); 
}


class _ProfileScreenState extends State<ProfileScreen>{
  
  int _currentIndex = 1;
  void _handleNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        AutoRouter.of(context).replace(const MapRoute());
        break;
      case 1:
        AutoRouter.of(context).replace(const ProfileRoute());
        break;
    }
  }

@override
  void initState(){
    super.initState();
  }

 @override
Widget build(BuildContext context) {
  return BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return Scaffold(
        appBar: (state is LoginSuccess || state is SessionRestored)
            ? UserInfoAppBar(
                user: state is LoginSuccess
                    ? state.user
                    : (state as SessionRestored).user,
                onSettings: () {
                  // Навигация к экрану настроек
                },
              )
            : null,
        body: Container(
          color: ColorsConstants.backgroundColor,
          child: Column(
            children: [
              // Блок управления профилем
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1.r,
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Кнопка управления профилем
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: () {
                          AutoRouter.of(context).replace(const ProfileSettingRoute());
                        },
                        child:  Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [ 
                              Icon(Icons.person_outline, size: 20.r),
                              SizedBox(width: 12.w),
                              Text('Управление профилем'),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios, size: 16.r),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Здесь можно добавить другие кнопки управления
                  ],
                ),
              ),
              
              // Кнопка выхода из аккаунта
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                    AutoRouter.of(context).replace(const WelcomeRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsConstants.primaryButtonBackgroundColor,
                    foregroundColor: ColorsConstants.primaryBrownColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Выйти из аккаунта'),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex, 
          onTap: _handleNavigationTap,
        ),
      );
    },
  );
}

}

class UserInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserEntity user;
  final VoidCallback? onLogout;
  final VoidCallback? onSettings;

  const UserInfoAppBar({
    super.key,
    required this.user,
    this.onLogout,
    this.onSettings,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100.h,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Row(
        children: [GestureDetector(
         onTap: () {
           print('Выбери изображение'); // Заглушка
         },
         child: CircleAvatar(
          backgroundColor: ColorsConstants.backgroundColor,
          foregroundColor: ColorsConstants.primaryBrownColor,
           radius: 30.r,
           child: Icon(Icons.person),
         ),
       ),
       SizedBox(width: 50.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user.name != null && user.surname != null)
                Text(
                  '${user.name} ${user.surname}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              if (user.role != null)
                Text(
                  '${user.role == 'customer' ? 'Заказчик' : 'Перевозчик'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      actions: [
          IconButton(
            icon: Icon(Icons.settings,
                color: ColorsConstants.primaryBrownColor, size: 40.r),
            onPressed: () {AutoRouter.of(context).replace(const SettingRoute());}
          ),
      ],
    );
  }
}