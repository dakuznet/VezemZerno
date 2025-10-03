import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/routes/router.dart';

class ProfileInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserEntity? user;

  const ProfileInfoAppBar({super.key, required this.user});

  @override
  Size get preferredSize => Size.fromHeight(150.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150.h,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
      ),
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Row(
        children: [
          _buildAvatar(),
          SizedBox(width: 12.w),
          Expanded(child: _buildUserInfo()),
        ],
      ),
      actions: [_buildSettingsButton(context)],
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 40.r,
      backgroundColor: ColorsConstants.backgroundColor,
      backgroundImage:
          user?.profileImage != null && user!.profileImage!.isNotEmpty
          ? NetworkImage(user!.profileImage!)
          : null,
      child: user?.profileImage == null || user!.profileImage!.isEmpty
          ? Icon(
              Icons.person,
              size: 32.sp,
              color: ColorsConstants.primaryBrownColor,
            )
          : null,
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (user?.name != null && user?.surname != null)
          Text(
            '${user!.name} ${user!.surname}',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w600,
              color: ColorsConstants.primaryBrownColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        if (user?.role != null)
          Text(
            _getRoleDisplayName(user!.role!),
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w300,
              fontSize: 14.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
      ],
    );
  }

  String _getRoleDisplayName(String role) {
    return switch (role) {
      'customer' => 'Заказчик',
      'carrier' => 'Перевозчик',
      _ => role,
    };
  }

  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset('assets/svg/settings_icon.svg'),
      onPressed: () => AutoRouter.of(context).push(const SettingRoute()),
    );
  }
}
