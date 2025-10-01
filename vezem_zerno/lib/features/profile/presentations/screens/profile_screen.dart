import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart'
    hide NoInternetConnection;
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/logout_confirmation_dialog.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_action_tile.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_error_appbar.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/profile_error_widget.dart';
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
    _loadProfile();
  }

  void _loadProfile() {
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  bool _shouldBlockInteractions(ProfileState state) {
    return state is ProfileError ||
        state is NoInternetConnection ||
        state is ProfileLoading ||
        state is ProfileInitial;
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
            if (profileState is ProfileError) {}
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
          : state is ProfileError || state is NoInternetConnection
          ? ErrorAppBar(onRetry: _loadProfile)
          : const ProfileShimmerAppBar(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfileState state,
    bool shouldBlockInteractions,
  ) {
    if (state is ProfileError || state is NoInternetConnection) {
      return ProfileErrorWidget(onRetry: _loadProfile);
    }

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileManagementSection(shouldBlockInteractions),
                _buildLogoutButton(context, state, shouldBlockInteractions),
                SizedBox(height: 16.h),
              ]),
            ),
          ],
        ),

        if (shouldBlockInteractions)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is ProfileError || state is NoInternetConnection) ...[
                  Icon(
                    state is NoInternetConnection
                        ? Icons.wifi_off
                        : Icons.error_outline,
                    size: 48.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.h),
                  PrimaryButton(
                    text: 'Повторить',
                    onPressed: state is AuthLoading ? null : _loadProfile,
                    isLoading: state is ProfileLoading,
                  ),
                ],
              ],
            ),
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
      if (state is ProfileError ||
          state is NoInternetConnection ||
          state is ProfileLoading) {
        _loadProfile();
      }
      return;
    }

    showDialog(
      context: context,
      builder: (context) => LogoutConfirmationDialog(),
    );
  }
}
