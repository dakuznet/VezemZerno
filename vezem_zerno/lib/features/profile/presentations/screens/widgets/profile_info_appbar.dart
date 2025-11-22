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
          CircleAvatar(
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
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4.h,
              children: [
                if (user?.name != null && user?.surname != null)
                  Text(
                    '${user!.name} ${user!.surname}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (user?.role != null)
                  Text(
                    user!.role,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 16.sp,
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
          icon: SvgPicture.asset('assets/svg/settings_icon.svg'),
          onPressed: () => context.router.push(const SettingRoute()),
        ),
      ],
    );
  }
}
