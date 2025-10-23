import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

@RoutePage()
class ApplicationsListScreen extends StatefulWidget {
  const ApplicationsListScreen({super.key});

  @override
  State<ApplicationsListScreen> createState() => _ApplicationsListScreenState();
}

class _ApplicationsListScreenState extends State<ApplicationsListScreen>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 2;

  late final TabController _tabController;
  List<ApplicationModel> _applications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    context.read<ApplicationsBloc>().add(
      LoadApplicationsEvent(applicationStatus: 'active'),
    );
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
      body: BlocConsumer<ApplicationsBloc, ApplicationsState>(
        listener: (context, state) {
          if (state is ApplicationsLoaded) {
            setState(() {
              _applications = state.applications;
            });
          }
        },
        builder: (context, state) {
          return _buildNestedScrollView(state);
        },
      ),
    );
  }

  Widget _buildNestedScrollView(ApplicationsState state) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildSliverAppBar(),
        _buildSliverTabBar(),
      ],
      body: _buildTabBarView(state),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      title: Text(
        'Заявки',
        style: TextStyle(
          fontSize: 20.sp,
          color: ColorsConstants.primaryBrownColor,
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
        height: _calculateTabBarHeight(context),
      ),
    );
  }

  double _calculateTabBarHeight(BuildContext context) {
    final rawHeight = 48.h;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return (rawHeight * devicePixelRatio).round() / devicePixelRatio;
  }

  Widget _buildTabBarView(ApplicationsState state) {
    return TabBarView(
      controller: _tabController,
      children: [_buildAllApplicationsTab(state), _buildMyResponsesTab()],
    );
  }

  Widget _buildAllApplicationsTab(ApplicationsState state) {
    return RefreshIndicator(
      color: ColorsConstants.primaryBrownColor,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      onRefresh: () async => context.read<ApplicationsBloc>().add(
        LoadApplicationsEvent(applicationStatus: 'active'),
      ),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (state is ApplicationsLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.w,
                  backgroundColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  color: ColorsConstants.primaryBrownColor,
                ),
              ),
            )
          else if (state is ApplicationsLoadingFailure)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Ошибка загрузки...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                ),
              ),
            )
          else if (_applications.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: ColorsConstants
                              .primaryTextFormFieldBackgorundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.list_alt_outlined,
                          size: 40.sp,
                          color: ColorsConstants.primaryBrownColorWithOpacity,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Список доступных заявок пуст',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsConstants.primaryBrownColorWithOpacity,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    ApplicationCard(application: _applications[index]),
                childCount: _applications.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMyResponsesTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                'Заявки с вашими откликами появятся здесь',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorsConstants.primaryBrownColorWithOpacity,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
          Tab(text: 'Все заявки'),
          Tab(text: 'С моим откликом'),
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
  bool shouldRebuild(covariant _TabBarSliverDelegate oldDelegate) {
    return tabController != oldDelegate.tabController ||
        height != oldDelegate.height;
  }
}
