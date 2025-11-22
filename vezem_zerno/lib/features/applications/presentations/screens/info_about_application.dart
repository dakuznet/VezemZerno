import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_info_column.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_info_row.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';

@RoutePage()
class InfoAboutApplicationScreen extends StatefulWidget {
  const InfoAboutApplicationScreen({super.key, required this.application});
  final ApplicationEntity application;
  @override
  State<InfoAboutApplicationScreen> createState() =>
      _InfoAboutApplicationScreenState();
}

class _InfoAboutApplicationScreenState
    extends State<InfoAboutApplicationScreen> {
  void _respondToApplication() {
    final userId = context.select<AuthBloc, String?>(
      (authBloc) => authBloc.state is LoginSuccess
          ? (authBloc.state as LoginSuccess).user.id
          : null,
    );

    if (userId != null) {
      context.read<ApplicationsBloc>().add(
        RespondToApplicaitonEvent(
          userId: userId,
          applicationId: widget.application.id!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplicationsBloc, ApplicationsState>(
      listener: (context, state) {
        if (state is RespondToApplicaitonLoadingSuccess) {
          PrimarySnackBar.show(
            context,
            text: 'Вы успешно откликнулись на заявку',
            borderColor: Colors.green,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorsConstants.backgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Заявка',
            style: TextStyle(
              fontSize: 20.sp,
              color: ColorsConstants.primaryBrownColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
          foregroundColor: ColorsConstants.primaryBrownColor,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            spacing: 16.sp,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Основная информация
              ApplicationInfoColumn(
                title: 'Основная информация',
                children: [
                  ApplicationInfoRow(
                    label: 'Культура',
                    value: widget.application.crop,
                  ),
                  ApplicationInfoRow(
                    label: 'Объем перевозки',
                    value: '${widget.application.tonnage} т',
                  ),
                  ApplicationInfoRow(
                    label: 'Цена',
                    value: '${widget.application.price} ₽/кг',
                  ),
                  ApplicationInfoRow(
                    label: 'Расстояние',
                    value: '${widget.application.distance} км',
                  ),
                  ApplicationInfoRow(
                    label: 'Дата создания',
                    value:
                        "${widget.application.createdAt!.day}.${widget.application.createdAt!.month}.${widget.application.createdAt!.year}",
                  ),
                ],
              ),

              // Маршрут
              ApplicationInfoColumn(
                title: 'Маршрут',
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2.w),
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 8.sp,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Погрузка',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color.fromARGB(134, 66, 44, 26),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${widget.application.loadingRegion}\n${widget.application.loadingLocality}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsConstants.primaryBrownColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.h,
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 2.w),
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 8.sp,
                            color: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Выгрузка',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color.fromARGB(134, 66, 44, 26),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${widget.application.loadingRegion}\n${widget.application.loadingLocality}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: ColorsConstants.primaryBrownColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Условия погрузки
              ApplicationInfoColumn(
                title: 'Условия погрузки',
                children: [
                  ApplicationInfoRow(
                    label: 'Способ погрузки',
                    value: widget.application.loadingMethod,
                  ),
                  ApplicationInfoRow(
                    label: 'Грузоподъемность весов',
                    value: '${widget.application.scalesCapacity} т',
                  ),
                  ApplicationInfoRow(
                    label: 'Дата погрузки',
                    value: widget.application.loadingDate,
                  ),
                ],
              ),

              // Детали перевозки
              ApplicationInfoColumn(
                title: 'Детали перевозки',
                children: [
                  ApplicationInfoRow(
                    label: 'Простой',
                    value: widget.application.downtime,
                  ),
                  ApplicationInfoRow(
                    label: 'Допустимая недостача',
                    value: '${widget.application.shortage} кг',
                  ),
                  ApplicationInfoRow(
                    label: 'Вид оплаты',
                    value: widget.application.paymentMethod,
                  ),
                  ApplicationInfoRow(
                    label: 'Сроки оплаты',
                    value: widget.application.paymentTerms,
                  ),
                  ApplicationInfoRow(
                    label: 'Самосвалы',
                    value: widget.application.dumpTrucks ? 'Да' : 'Нет',
                  ),
                  ApplicationInfoRow(
                    label: 'Перевозчик работает по хартии',
                    value: widget.application.charter ? 'Да' : 'Нет',
                  ),
                ],
              ),

              // Заказчик
              ApplicationInfoColumn(
                title: 'Заказчик',
                children: [
                  ApplicationInfoRow(
                    label: 'Организация',
                    value: widget.application.organization,
                  ),
                ],
              ),

              //Комментарий
              ApplicationInfoColumn(
                title: 'Комментарий',
                children: [
                  Text(
                    widget.application.comment,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsConstants.primaryBrownColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final bool isCustomer = authState is SessionRestored
                      ? authState.user.role == 'Перевозчик'
                      : authState is LoginSuccess
                      ? authState.user.role == 'Перевозчик'
                      : false;

                  if (!isCustomer) return const SizedBox.shrink();

                  return PrimaryButton(
                    text: 'Откликнуться',
                    onPressed: () => _respondToApplication,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
