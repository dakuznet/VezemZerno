import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoggingOut = state is AuthLoading;
        //final hasConnectionError = state is NoInternetConnection;

        return AlertDialog(
          backgroundColor: ColorsConstants.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Выйти из аккаунта',
            style: TextStyle(
              //fontFamily: 'Unbounded',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
          content: 
          // hasConnectionError
          //     ? Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Icon(
          //             Icons.wifi_off,
          //             size: 40.sp,
          //             color: ColorsConstants.primaryBrownColor,
          //           ),
          //           SizedBox(height: 12.h),
          //           Text(
          //             'Проверьте интернет-соединение перед выходом',
          //             style: TextStyle(
          //               fontFamily: 'Unbounded',
          //               fontSize: 14.sp,
          //               fontWeight: FontWeight.w400,
          //               color: const Color.fromARGB(195, 66, 44, 26),
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ],
          //       )
          //     :
               Text(
                  'Вы уверены что хотите выйти из аккаунта?',
                  style: TextStyle(
                    //fontFamily: 'Unbounded',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(195, 66, 44, 26),
                  ),
                ),
          actions: 
          // hasConnectionError
          //     ? 
          //     [
          //         Center(
          //           child: TextButton(
          //             onPressed: () => AutoRouter.of(context).pop(),
          //             style: TextButton.styleFrom(
          //               foregroundColor: ColorsConstants.primaryBrownColor,
          //             ),
          //             child: Text(
          //               'Повторить',
          //               style: TextStyle(
          //                 color: ColorsConstants.primaryBrownColor,
          //                 fontSize: 14.sp,
          //                 fontFamily: 'Unbounded',
          //                 fontWeight: FontWeight.w400,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ]
          //     : 
              [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => isLoggingOut
                              ? null
                              : AutoRouter.of(context).pop(),
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
                              fontSize: 16.sp,
                              //fontFamily: 'Unbounded',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton(
                          onPressed: isLoggingOut
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                    AuthLogoutEvent(),
                                  );

                                  AutoRouter.of(context).pop();
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Выйти',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              //fontFamily: 'Unbounded',
                              fontWeight: FontWeight.w500,
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
