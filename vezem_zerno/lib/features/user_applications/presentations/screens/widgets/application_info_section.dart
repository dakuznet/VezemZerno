import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_info_card.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_info_location_row.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_info_row.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/carrier_info_widget.dart';

class ApplicationInfoSection extends StatelessWidget {
  final ApplicationEntity application;
  final bool isCustomer;
  final UserApplicationsState blocState;

  const ApplicationInfoSection({
    super.key,
    required this.application,
    required this.isCustomer,
    required this.blocState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ApplicationInfoCard(
          title: 'Основная информация',
          children: [
            ApplicationInfoRow(label: 'Культура', value: application.crop),
            ApplicationInfoRow(
              label: 'Объем перевозки',
              value: '${application.tonnage} т',
            ),
            ApplicationInfoRow(
              label: 'Цена',
              value: '${application.price} ₽/кг',
            ),
            ApplicationInfoRow(
              label: 'Расстояние',
              value: '${application.distance} км',
            ),
            ApplicationInfoRow(
              label: 'Дата публикации',
              value: _formatDate(application.createdAt),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ApplicationInfoCard(
          title: 'Маршрут',
          children: [
            ApplicationInfoLocationRow(
              type: 'Погрузка',
              location:
                  '${application.loadingRegion}\n${application.loadingLocality}',
            ),
            ApplicationInfoLocationRow(
              type: 'Выгрузка',
              location:
                  '${application.unloadingRegion}\n${application.unloadingLocality}',
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ApplicationInfoCard(
          title: 'Условия погрузки',
          children: [
            ApplicationInfoRow(
              label: 'Способ погрузки',
              value: application.loadingMethod,
            ),
            ApplicationInfoRow(
              label: 'Грузоподъемность весов',
              value: '${application.scalesCapacity} т',
            ),
            ApplicationInfoRow(
              label: 'Дата погрузки',
              value: application.loadingDate,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ApplicationInfoCard(
          title: 'Детали перевозки',
          children: [
            ApplicationInfoRow(label: 'Простой', value: application.downtime),
            ApplicationInfoRow(
              label: 'Допустимая недостача',
              value: '${application.shortage} кг',
            ),
            ApplicationInfoRow(
              label: 'Способ оплаты',
              value: application.paymentMethod,
            ),
            ApplicationInfoRow(
              label: 'Сроки оплаты',
              value: application.paymentTerms,
            ),
            ApplicationInfoRow(
              label: 'Самосвалы',
              value: application.dumpTrucks ? 'Да' : 'Нет',
            ),
            ApplicationInfoRow(
              label: 'Перевозчик работает по хартии',
              value: application.charter ? 'Да' : 'Нет',
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ApplicationInfoCard(
          title: 'Заказчик',
          children: [
            ApplicationInfoRow(
              label: 'Организация',
              value: application.organization,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ApplicationInfoCard(
          title: 'Комментарий',
          children: [
            Text(
              application.comment,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
          ],
        ),
        if (isCustomer &&
            (application.status == 'processing' ||
                application.status == 'completed')) ...[
          SizedBox(height: 16.h),
          CarrierInfoWidget(application: application, blocState: blocState),
        ],
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Не указана';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
