import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/core/widgets/primary_divider.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_info_chip.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationEntity application;
  final void Function() onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = application.createdAt;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        margin: EdgeInsets.all(16.w),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Опубликовано ${date!.day}.${date.month}.${date.year}",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color.fromARGB(172, 66, 44, 26),
                    ),
                  ),
                  Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 24.sp,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ],
              ),
              SizedBox(height: 8.h,),
              const PrimaryDivider(),
              SizedBox(height: 8.h,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Откуда: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: const Color.fromARGB(172, 66, 44, 26),
                            ),
                            children: [
                              TextSpan(
                                text: '${application.loadingRegion}\n${application.loadingLocality}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: ColorsConstants.primaryBrownColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Куда: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: const Color.fromARGB(172, 66, 44, 26),
                            ),
                            children: [
                              TextSpan(
                                text: '${application.unloadingRegion}\n${application.unloadingLocality}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                  color: ColorsConstants.primaryBrownColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    '${application.price} ₽/кг',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ApplicationInfoChip(info: application.crop),
                  ApplicationInfoChip(info: '${application.tonnage} тонн'),
                  ApplicationInfoChip(info: '${application.distance} км'),
                ],
              ),
              SizedBox(height: 8.h,),
              const PrimaryDivider(),
              SizedBox(height: 8.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Заказчик",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: const Color.fromARGB(172, 66, 44, 26),
                    ),
                  ),
                  Text(
                    application.organization,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (application.status == 'processing' && application.delivered)
                Row(
                  spacing: 8.w,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 24.sp,
                      color: ColorsConstants.primaryBrownColor,
                      weight: 5,
                    ),
                    Text(
                      'Ожидает подтверждения заказчика',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: const Color.fromARGB(172, 66, 44, 26),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
