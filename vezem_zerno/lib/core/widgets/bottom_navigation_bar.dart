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
        elevation: 0.0,
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColorWithOpacity,
          ),
          selectedLabelStyle: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorsConstants.primaryBrownColor,
          ),
          selectedItemColor: ColorsConstants.primaryBrownColor,
          unselectedItemColor: ColorsConstants.primaryBrownColorWithOpacity,
          currentIndex: currentIndex,
          onTap: onTap,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined, size: 24.sp),
              label: 'Мои заявки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 24.sp),
              label: 'Все заявки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined, size: 24.sp),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
