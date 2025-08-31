import 'package:flutter/material.dart';
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
        canvasColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      ),
      child: BottomNavigationBar(
        selectedItemColor: ColorsConstants.primaryBrownColor,
        unselectedItemColor: ColorsConstants.primaryBrownColorWithOpacity,
        currentIndex: currentIndex,
        onTap: onTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Карта',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}