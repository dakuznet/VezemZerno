import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class TabBarSliverDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final double height;

  TabBarSliverDelegate({
    required this.tabController,
    required this.height,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      height: height,
      child: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'Активные'),
          Tab(text: 'В работе'),
          Tab(text: 'Завершённые'),
        ],
        labelColor: ColorsConstants.primaryBrownColor,
        labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        unselectedLabelColor: ColorsConstants.primaryBrownColorWithOpacity,
        unselectedLabelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: ColorsConstants.primaryBrownColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2.0,
        splashBorderRadius: BorderRadius.zero,
        labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant TabBarSliverDelegate oldDelegate) {
    return tabController != oldDelegate.tabController ||
        height != oldDelegate.height;
  }
}
