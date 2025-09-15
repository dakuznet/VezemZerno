import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/domain/entities/user_entity.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        UserEntity? user;
        if (state is ProfileLoaded) {
          user = UserEntity(
            name: state.user.name,
            surname: state.user.surname,
            role: state.user.role,
            id: state.user.id,
            phone: state.user.phone,
            profileImage: state.user.profileImage,
          );
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150.h),
            child: (state is ProfileLoading || user == null)
                ? const ShimmerAppBar()
                : UserInfoAppBar(user: user),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Блок управления профилем
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16).w,
                  padding: const EdgeInsets.all(16).w,
                  decoration: BoxDecoration(
                    color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Кнопка управления профилем
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(32.r),
                          onTap: () {
                            AutoRouter.of(
                              context,
                            ).replace(const ProfileSettingRoute());
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h).w,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/user_edit_icon.svg',
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  'Управление профилем',
                                  style: TextStyle(
                                    fontFamily: 'Undounded',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 20.sp),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1.0,
                        color: ColorsConstants.primaryBrownColorWithOpacity,
                      ),
                      // Здесь можно добавить другие кнопки управления
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(32.r),
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h).w,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/password_edit_icon.svg',
                                  width: 24.w,
                                  height: 18.h,
                                ),
                                SizedBox(width: 16.w),
                                Text(
                                  'Изменение пароля',
                                  style: TextStyle(
                                    fontFamily: 'Undounded',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 20.sp),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Кнопка выхода из аккаунта
                PrimaryButton(
                  text: 'Выйти из аккаунта',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: false,
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          backgroundColor: ColorsConstants.backgroundColor,
                          title: Text(
                            'Выйти из аккаунта',
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstants.primaryBrownColor,
                            ),
                          ),
                          content: Text(
                            'Вы уверены что хотите выйти из аккаунта?',
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(195, 66, 44, 26),
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Закрывает диалог
                              },
                              style: ElevatedButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                elevation: 4.r,
                                backgroundColor: ColorsConstants
                                    .primaryButtonBackgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.r),
                                  side: BorderSide(
                                    color: ColorsConstants
                                        .primaryButtonBorderColor,
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
                              onPressed: () {
                                context.read<AuthBloc>().add(LogoutEvent());
                                AutoRouter.of(
                                  context,
                                ).replace(const WelcomeRoute());
                              },
                              style: ElevatedButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                elevation: 4.r,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.r),
                                ),
                              ),
                              child: Text(
                                'Выйти',
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
                ),
              ],
            ),
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
  Size get preferredSize => const Size.fromHeight(150);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150.h,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
      ),
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: ColorsConstants.backgroundColor,
            radius: 50.r,
            backgroundImage:
                user.profileImage != null && user.profileImage!.isNotEmpty
                ? NetworkImage(user.profileImage!) as ImageProvider
                : null,
            child: user.profileImage == null || user.profileImage!.isEmpty
                ? Icon(
                    Icons.person,
                    size: 50.sp,
                    color: ColorsConstants.primaryBrownColor,
                  )
                : null,
          ),
          SizedBox(width: 12.w,),
          Expanded(
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.name != null && user.surname != null)
                  Text(
                    '${user.name} ${user.surname}',
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w600,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                if (user.role != null)
                  Text(
                    user.role == 'customer' ? 'Заказчик' : 'Перевозчик',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w300,
                      fontSize: 14.sp,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.only(right: 30.w).w,
          icon: SvgPicture.asset('assets/svg/settings_icon.svg'),
          color: ColorsConstants.primaryBrownColor,
          onPressed: () {
            AutoRouter.of(context).replace(const SettingRoute());
          },
        ),
      ],
    );
  }
}

class ShimmerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShimmerAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(150.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
      ),
      toolbarHeight: 150.h,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: ColorsConstants.primaryBrownColorWithOpacity,
        highlightColor: ColorsConstants.primaryBrownColorWithOpacity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Аватар
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: ColorsConstants.primaryBrownColorWithOpacity,
                shape: BoxShape.circle,
              ),
            ),
            // Имя и роль
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120.w,
                  height: 20.h,
                  color: ColorsConstants.primaryBrownColorWithOpacity,
                  margin: EdgeInsets.only(bottom: 10.h).h,
                ),
                Container(
                  width: 80.w,
                  height: 16.h,
                  color: ColorsConstants.primaryBrownColorWithOpacity,
                ),
              ],
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }
}
