// profile_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart'
    hide NoInternetConnection;
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

  bool _shouldBlockInteractions(ProfileState state) {
    return state is ProfileLoading ||
        state is ProfileInitial ||
        state is ProfileSaving ||
        state is PasswordUpdating ||
        state is AccountDeleting;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, authState) {
            if (authState is Unauthenticated) {
              AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, profileState) {
            if (profileState is NoInternetConnection) {
              PrimarySnackBar.show(
                context,
                text: 'Проверьте соединение с интернетом',
                borderColor: Colors.red,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final shouldBlockInteractions = _shouldBlockInteractions(state);

          return Scaffold(
            backgroundColor: ColorsConstants.backgroundColor,
            body: Column(
              children: [
                _buildAppBar(state),
                Expanded(
                  child: _buildContent(context, state, shouldBlockInteractions),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ProfileState state) {
    return PreferredSize(
      preferredSize: Size.fromHeight(150.h),
      child: state is ProfileLoading || state is ProfileInitial
          ? const ProfileShimmerAppBar()
          : state is ProfileLoaded
          ? ProfileInfoAppBar(user: state.user)
          : const ProfileShimmerAppBar(),
    );
  }

  Widget _buildLoadingIndicator() {
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

  Widget _buildContent(
    BuildContext context,
    ProfileState state,
    bool shouldBlockInteractions,
  ) {
    final hasNoInternet = state is NoInternetConnection;

    if (hasNoInternet) {
      return _buildLoadingIndicator();
    }
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _buildProfileManagementSection(shouldBlockInteractions),
            _buildLogoutButton(context, state, shouldBlockInteractions),
            SizedBox(height: 16.h),
          ]),
        ),
      ],
    );
  }

  Widget _buildProfileManagementSection(bool shouldBlockInteractions) {
    return AbsorbPointer(
      absorbing: shouldBlockInteractions,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: ColorsConstants.primaryTextFormFieldBackgorundColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileActionTile(
              iconPath: 'assets/svg/user_edit_icon.svg',
              title: 'Управление профилем',
              onTap: () => shouldBlockInteractions
                  ? null
                  : AutoRouter.of(context).push(const ProfileSettingRoute()),
            ),
            Divider(
              thickness: 1.0.sp,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
            ProfileActionTile(
              iconPath: 'assets/svg/password_edit_icon.svg',
              title: 'Изменение пароля',
              iconSize: Size(24.w, 14.h),
              onTap: () => shouldBlockInteractions
                  ? null
                  : AutoRouter.of(context).push(const ChangePasswordRoute()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    ProfileState state,
    bool shouldBlockInteractions,
  ) {
    final isBlocked = shouldBlockInteractions;

    return AbsorbPointer(
      absorbing: isBlocked,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: PrimaryButton(
          text: 'Выйти из аккаунта',
          onPressed: () => _showLogoutConfirmationDialog(context),
          isLoading: state is AuthLoading,
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final state = context.read<ProfileBloc>().state;

    if (_shouldBlockInteractions(state)) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const LogoutConfirmationDialog(),
    );
  }
}
