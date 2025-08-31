import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/bottom_navigation_bar.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
 
  int _currentIndex = 0;
 
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorsConstants.backgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.exit_to_app),
                color: ColorsConstants.primaryBrownColor,
                iconSize: 50.r,
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  AutoRouter.of(context).replace(const WelcomeRoute());
                },
              ),
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: ColorsConstants.backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.0.w).r,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Отображаем информацию о пользователе
                    if (state is LoginSuccess || state is SessionRestored)
                      _buildUserInfo(
                        state is LoginSuccess
                            ? (state).user
                            : (state as SessionRestored).user,
                      ),
                  ],
                ),
              ),
            ),

            bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex, onTap: _handleNavigationTap)
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(UserEntity user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

        if (user.organization != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              user.organization!,
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Text(
            'Телефон: ${user.phone}',
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ),

        if (user.role != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              'Роль: ${user.role == 'customer' ? 'Заказчик' : 'Перевозчик'}',
              style: TextStyle(
                fontSize: 16.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
          ),
      ],
    );
  }
}
