import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';

class CarrierInfoWidget extends StatelessWidget {
  final ApplicationEntity application;
  final UserApplicationsState blocState;

  const CarrierInfoWidget({
    super.key,
    required this.application,
    required this.blocState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Перевозчик',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            SizedBox(height: 12.h),
            ...[
              BlocBuilder<UserApplicationsBloc, UserApplicationsState>(
                builder: (context, state) {
                  if (state is LoadingCarrierInfo) {
                    return const PrimaryLoadingIndicator();
                  } else if (state is LoadingCarrierInfoSuccess) {
                    final carrier = state.carrier;
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Имя',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color.fromARGB(
                                      134,
                                      66,
                                      44,
                                      26,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${carrier.name} ${carrier.surname}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                  textAlign: TextAlign.right,
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
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Организация',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color.fromARGB(
                                      134,
                                      66,
                                      44,
                                      26,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  carrier.organization,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                  textAlign: TextAlign.right,
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
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Телефон',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: const Color.fromARGB(
                                      134,
                                      66,
                                      44,
                                      26,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '+${carrier.phone}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConstants.primaryBrownColor,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Не удалось загрузить информацию о перевозчике\n${context.read<UserApplicationsBloc>().state}',
                        style: TextStyle(fontSize: 14.sp, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
