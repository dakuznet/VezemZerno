import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/application_entiry.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationEntity application;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Опубликовано ${application.date}",
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
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
        _buildLocationRow(label: 'Откуда:', value: application.from),
        if (application.to.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _buildLocationRow(label: 'Куда:', value: application.to),
        ],
      ],
    );
  }

  Widget _buildLocationRow({required String label, required String value}) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          color: const Color.fromARGB(172, 66, 44, 26),
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTariffChip() {
    return Text(
      application.tariff,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Unbounded',
        fontWeight: FontWeight.w400,
        color: ColorsConstants.primaryBrownColor,
      ),
    );
  }

  Widget _buildCargoInfo() {
    final List<Widget> cargoChips = [];

    if (application.cargo.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.cargo));
    }

    if (application.weight.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.weight));
    }

    if (application.distance.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.distance));
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
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w400,
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
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: const Color.fromARGB(172, 66, 44, 26),
          ),
        ),
        Text(
          application.customer,
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ],
    );
  }
}
