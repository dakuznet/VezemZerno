// profile_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_divider.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/logout_confirmation_dialog.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_action_tile.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_info_appbar.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_shimmer_appbar.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          PrimarySnackBar.show(
            context,
            text: 'Произошла ошибка...\nПроверьте соединение с интернетом',
            borderColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorsConstants.backgroundColor,
          body: Column(
            children: [
              PreferredSize(
                preferredSize: Size.fromHeight(150.h),
                child: state is ProfileLoading || state is ProfileInitial
                    ? const ProfileShimmerAppBar()
                    : state is ProfileLoaded
                    ? ProfileInfoAppBar(user: state.user)
                    : const ProfileShimmerAppBar(),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(16.w),
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: ColorsConstants
                                .primaryTextFormFieldBackgorundColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileActionTile(
                                iconPath: 'assets/svg/user_edit_icon.svg',
                                title: 'Управление профилем',
                                onTap: () => context.router.push(
                                  ProfileSettingRoute(
                                    user: state is ProfileLoaded
                                        ? state.user
                                        : null,
                                  ),
                                ),
                              ),
                              const PrimaryDivider(),
                              ProfileActionTile(
                                iconPath: 'assets/svg/password_edit_icon.svg',
                                title: 'Изменение пароля',
                                iconSize: Size(24.w, 14.h),
                                onTap: () => context.router.push(
                                  const ChangePasswordRoute(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: PrimaryButton(
                            text: 'Выйти из аккаунта',
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  const LogoutConfirmationDialog(),
                            ),
                            isLoading: state is AuthLoading,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
