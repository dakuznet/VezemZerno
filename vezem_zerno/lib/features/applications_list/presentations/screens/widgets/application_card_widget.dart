import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_application_list/data/models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),
            _buildDivider(),
            _buildLocationWithTariff(),
            SizedBox(height: 16.h),
            _buildCargoInfo(),
            _buildDivider(),
            _buildCustomerInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    final DateTime? date = application.createdAt;
    return Row(
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
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Divider(
        height: 2.h,
        color: ColorsConstants.primaryBrownColorWithOpacity,
      ),
    );
  }

  Widget _buildLocationWithTariff() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildLocationInfo()),
        SizedBox(width: 16.w),
        _buildTariffChip(),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationRow(label: 'Откуда:', value: application.loadingPlace),
        if (application.unloadingPlace.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _buildLocationRow(label: 'Куда:', value: application.unloadingPlace),
        ],
      ],
    );
  }

  Widget _buildLocationRow({required String label, required String value}) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color.fromARGB(172, 66, 44, 26),
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTariffChip() {
    return Text(
      '${application.price} ₽/кг',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: ColorsConstants.primaryBrownColor,
      ),
    );
  }

  Widget _buildCargoInfo() {
    final List<Widget> cargoChips = [];

    if (application.crop.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.crop));
    }

    if (application.tonnage.isNotEmpty) {
      cargoChips.add(_buildCargoChip('${application.tonnage} тонн'));
    }

    if (application.distance.isNotEmpty) {
      cargoChips.add(_buildCargoChip('${application.distance} км'));
    }

    return Wrap(spacing: 8.w, runSpacing: 8.h, children: cargoChips);
  }

  Widget _buildCargoChip(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsConstants.primaryBrownColor,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ColorsConstants.primaryBrownColor,
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
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
    );
  }
}
