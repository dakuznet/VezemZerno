import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/user_entity.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';

class UserResponseCard extends StatelessWidget {
  final UserEntity user;
  final String applicationId;

  const UserResponseCard({
    super.key,
    required this.user,
    required this.applicationId,
  });

  void _acceptResponse(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is LoginSuccess ? authState.user.id : null;
    context.read<UserApplicationsBloc>().add(
      AcceptResponseEvent(
        carrierId: user.id,
        applicationId: applicationId,
        userId: userId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      ),
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: ColorsConstants.backgroundColor,
                backgroundImage: user.profileImage!.isNotEmpty
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: user.profileImage!.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 24.sp,
                        color: ColorsConstants.primaryBrownColor,
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      Text(
                        '${user.name} ${user.surname}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: ColorsConstants.primaryBrownColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    if (user.organization.isNotEmpty) ...[
                      Text(
                        user.organization,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsConstants.primaryBrownColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    ...[
                      Text(
                        '+${user.phone}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsConstants.primaryBrownColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          BlocBuilder<UserApplicationsBloc, UserApplicationsState>(
            builder: (context, state) {
              final isLoading = state is ResponseAccepting;
              return PrimaryButton(
                isLoading: isLoading,
                text: 'Принять',
                onPressed: () => _acceptResponse(context),
              );
            },
          ),
        ],
      ),
    );
  }
}
