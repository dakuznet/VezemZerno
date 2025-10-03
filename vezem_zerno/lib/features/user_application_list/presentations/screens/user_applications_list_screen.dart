import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';

@RoutePage()
class UserApplicationsListScreen extends StatefulWidget {
  const UserApplicationsListScreen({super.key});

  @override
  State<UserApplicationsListScreen> createState() =>
      _UserApplicationsListScreenState();
}

class _UserApplicationsListScreenState extends State<UserApplicationsListScreen>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 2;

  late final TabController _tabController;
  bool _isEmptyState = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: _buildNestedScrollView(),
      bottomNavigationBar: _buildCreateApplicationButton(),
    );
  }

  Widget _buildCreateApplicationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 16.h),
      child: PrimaryButton(
        text: 'Создать заявку',
        onPressed: () {
          // TODO: Добавьте обработчик нажатия для создания заявки
        },
      ),
    );
  }

  Widget _buildNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildSliverAppBar(),
        _buildSliverTabBar(),
      ],
      body: _buildTabBarView(),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Text(
        'Мои заявки',
        style: TextStyle(
          fontSize: 16.sp,
          color: ColorsConstants.primaryBrownColor,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 4,
      surfaceTintColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
    );
  }

  SliverPersistentHeader _buildSliverTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarSliverDelegate(
        tabController: _tabController,
        // Явно задаем высоту и округляем до целого пикселя
        height: _calculateTabBarHeight(context),
      ),
    );
  }

  double _calculateTabBarHeight(BuildContext context) {
    // Вычисляем высоту TabBar и округляем до целого пикселя
    final rawHeight = 48.h;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return (rawHeight * devicePixelRatio).round() / devicePixelRatio;
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [_buildActiveTabContent(), _buildHistoryTabContent()],
    );
  }

  Widget _buildActiveTabContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _isEmptyState
              ? _buildEmptyState(isActiveTab: true)
              : _buildCustomsList(), // TODO: Implement list builder when data is available
        ),
      ],
    );
  }

  Widget _buildHistoryTabContent() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _isEmptyState
              ? _buildEmptyState(isActiveTab: false)
              : _buildCustomsList(), // TODO: Implement list builder when data is available
        ),
      ],
    );
  }

  Widget _buildEmptyState({required bool isActiveTab}) {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: ColorsConstants.primaryTextFormFieldBackgorundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.list_alt_outlined,
              size: 40.sp,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            isActiveTab
                ? 'У вас нет ни одной активной заявки'
                : 'У вас нет ни одной архивной заявки',
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomsList() {
    // TODO: Implement actual list builder when data is available
    return const SizedBox.shrink();
  }
}

class _TabBarSliverDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final double height;

  _TabBarSliverDelegate({required this.tabController, required this.height});

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
          Tab(text: 'Архив'),
        ],
        labelColor: ColorsConstants.primaryBrownColor,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: ColorsConstants.primaryBrownColorWithOpacity,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Unbounded',
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
  bool shouldRebuild(covariant _TabBarSliverDelegate oldDelegate) {
    return tabController != oldDelegate.tabController ||
        height != oldDelegate.height;
  }
}
