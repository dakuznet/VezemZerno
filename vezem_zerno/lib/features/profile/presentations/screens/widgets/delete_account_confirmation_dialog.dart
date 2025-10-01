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
            if (!isDeleting)
              TextButton(
                onPressed: () => AutoRouter.of(context).pop(),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: isDeleting
                  ? null
                  : () {
                      context.read<ProfileBloc>().add(DeleteAccountEvent());
                    },
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                elevation: 4.r,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r),
                ),
              ),
              child: isDeleting
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                        color: ColorsConstants.primaryBrownColor,
                      ),
                    )
                  : Text(
                      'Удалить',
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
  }
}
