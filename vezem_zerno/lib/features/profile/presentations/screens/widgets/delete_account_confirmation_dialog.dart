import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_event.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final isDeleting = state is AccountDeleting;
        return AlertDialog(
          scrollable: false,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          backgroundColor: ColorsConstants.backgroundColor,
          title: Text(
            'Удалить аккаунт',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
          content: Text(
            'Вы уверены, что хотите удалить свой аккаунт? Все ваши данные будут безвозвратно удалены.',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(195, 66, 44, 26),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () =>
                        isDeleting ? null : AutoRouter.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: ColorsConstants.primaryBrownColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: TextStyle(
                        color: ColorsConstants.primaryBrownColor,
                        fontSize: 14.sp,
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () => isDeleting
                        ? null
                        : {
                            context.read<ProfileBloc>().add(
                              DeleteAccountEvent(),
                            ),
                            AutoRouter.of(context).pop(),
                          },
                    style: FilledButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      elevation: 4.r,
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Удалить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
