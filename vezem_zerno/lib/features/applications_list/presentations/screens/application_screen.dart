import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/features/applications_list/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/features/user_application_list/data/models/application_model.dart';

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
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      AppwriteService appwriteService = AppwriteService();

      final applications = await appwriteService.getAllApplicationsByStatus(
        'active',
      );

      setState(() {
        _applications = applications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки заявок: $e';
        _isLoading = false;
      });
    }
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

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [_buildAllApplicationsTab(), _buildMyResponsesTab()],
    );
  }

  Widget _buildAllApplicationsTab() {
    return RefreshIndicator(
      color: ColorsConstants.primaryBrownColor,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      onRefresh: _loadApplications,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (_isLoading)
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
          else if (_error.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    _error,
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
