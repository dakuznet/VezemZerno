import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class PhoneVerificationScreen extends StatefulWidget {
  final String phone;
  final String password;

  const PhoneVerificationScreen({
    super.key,
    @PathParam('phone') required this.phone,
    @PathParam('password') required this.password,
  });

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorsConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ColorsConstants.primaryBrownColor,
          iconSize: 30.r,
          onPressed: () => AutoRouter.of(context).back(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Ошибка регистрации...',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 14.sp,
                      color: ColorsConstants.primaryBrownColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is VerificationCodeSuccess) {
              AutoRouter.of(context).replaceAll([const LoginRoute()]);
              // } else if (state is VerificationCodeResent) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //         'Код отправлен повторно',
              //         style: TextStyle(
              //           fontFamily: 'Unbounded',
              //           fontSize: 14.sp,
              //           color: ColorsConstants.primaryBrownColor,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //       backgroundColor:
              //           ColorsConstants.primaryTextFormFieldBackgorundColor,
              //       behavior: SnackBarBehavior.floating,
              //     ),
              //   );
              // }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.r).r,
              child: Column(
                children: [
                  Text(
                    'Подтверждение номера',
                    style: TextStyle(
                      fontFamily: 'Unbounded',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Мы отправили SMS с кодом подтверждения на номер\n${widget.phone}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PrimaryTextFormField(
                    controller: _codeController,
                    labelText: 'Код из SMS',
                    keyboardType: TextInputType.number,
                  ),

                  if (state is AuthFailure && _codeController.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ),

                  SizedBox(height: 24.h),
                  if (state is AuthLoading)
                    const CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor:
                          ColorsConstants.primaryTextFormFieldBackgorundColor,
                      color: ColorsConstants.primaryBrownColor,
                    )
                  else
                    PrimaryButton(
                      text: 'Подтвердить',
                      onPressed: () {
                        if (_codeController.text.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Введите 6-значный код',
                                style: TextStyle(
                                  fontFamily: 'Unbounded',
                                  fontSize: 14.sp,
                                  color: ColorsConstants.primaryBrownColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: ColorsConstants
                                  .primaryTextFormFieldBackgorundColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        context.read<AuthBloc>().add(
                          VerifyCodeEvent(
                            phone: widget.phone,
                            code: _codeController.text,
                          ),
                        );
                      },
                    ),

                  // SizedBox(height: 16.h),
                  // TextButton(
                  //   onPressed: state is AuthLoading
                  //       ? null
                  //       : () {
                  //           context.read<AuthBloc>().add(
                  //             ResendCodeEvent(
                  //               phone: widget.phone,
                  //               password: widget.password,
                  //             ),
                  //           );
                  //         },
                  //   child: Text(
                  //     "Отправить код повторно",
                  //     style: TextStyle(
                  //       fontFamily: 'Unbounded',
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w500,
                  //       color: ColorsConstants.primaryBrownColor,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
