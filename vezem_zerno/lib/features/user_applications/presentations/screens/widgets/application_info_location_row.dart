import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class ApplicationInfoLocationRow extends StatelessWidget {
  const ApplicationInfoLocationRow({
    super.key,
    required this.type,
    required this.location,
  });
  final String type;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              border: Border.all(
                color: type == 'Погрузка' ? Colors.blue : Colors.red,
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.circle,
              size: 8.sp,
              color: type == 'Погрузка' ? Colors.blue : Colors.red,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color.fromARGB(134, 66, 44, 26),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  location,
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
    );
  }
}
