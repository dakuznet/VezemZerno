import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Material(
        type: MaterialType.canvas,
        elevation: 0.0.sp,
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: BottomNavigationBar(
          elevation: 0.sp,
          backgroundColor: Colors.transparent,
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColorWithOpacity,
          ),
          selectedIconTheme: IconThemeData(size: 26.sp),
          unselectedIconTheme: IconThemeData(size: 24.sp),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
          selectedItemColor: ColorsConstants.primaryBrownColor,
          unselectedItemColor: ColorsConstants.primaryBrownColorWithOpacity,
          currentIndex: currentIndex,
          onTap: onTap,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined),
              label: 'Мои заявки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'Все заявки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
