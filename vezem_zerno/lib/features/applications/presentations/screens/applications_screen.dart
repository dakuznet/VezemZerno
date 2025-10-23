import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';
import 'package:vezem_zerno/routes/router.dart';

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
  List<ApplicationModel> _filteredApplications = [];
  ApplicationFilter _currentFilter = ApplicationFilter();

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

  void _applyFilter(ApplicationFilter filter) {
    setState(() {
      _currentFilter = filter;
      _filteredApplications = _filterApplications(_applications, filter);
    });
  }

  List<ApplicationModel> _filterApplications(
      List<ApplicationModel> applications, ApplicationFilter filter) {
    return applications.where((app) {
      
      if (filter.loadingRegion != null && 
          filter.loadingRegion!.isNotEmpty &&
          !app.loadingPlace.toLowerCase().contains(filter.loadingRegion!.toLowerCase())) {
        return false;
      }

     
      if (filter.loadingDistrict != null && 
          filter.loadingDistrict!.isNotEmpty &&
          !app.loadingPlace.toLowerCase().contains(filter.loadingDistrict!.toLowerCase())) {
        return false;
      }

    
      if (filter.unloadingRegion != null && 
          filter.unloadingRegion!.isNotEmpty &&
          !app.unloadingPlace.toLowerCase().contains(filter.unloadingRegion!.toLowerCase())) {
        return false;
      }

        
      if (filter.unloadingDistrict != null && 
          filter.unloadingDistrict!.isNotEmpty &&
          !app.unloadingPlace.toLowerCase().contains(filter.unloadingDistrict!.toLowerCase())) {
        return false;
      }

      
      if (filter.crop != null && 
          filter.crop!.isNotEmpty &&
          !app.crop.toLowerCase().contains(filter.crop!.toLowerCase())) {
        return false;
      }

      
      final appPrice = double.tryParse(app.price.replaceAll(',', '.'));
      if (filter.minPrice != null && appPrice != null) {
        if (appPrice < filter.minPrice!) return false;
      }
      if (filter.maxPrice != null && appPrice != null) {
        if (appPrice > filter.maxPrice!) return false;
      }

      
      final appDistance = double.tryParse(app.distance.replaceAll(',', '.'));
      if (filter.minDistance != null && appDistance != null) {
        if (appDistance < filter.minDistance!) return false;
      }
      if (filter.maxDistance != null && appDistance != null) {
        if (appDistance > filter.maxDistance!) return false;
      }

      
      if (app.createdAt != null) {
        final now = DateTime.now();
        final difference = now.difference(app.createdAt!).inDays;
        
        switch (filter.dateFilter) {
          case DateFilter.last3Days:
            if (difference > 3) return false;
            break;
          case DateFilter.last5Days:
            if (difference > 5) return false;
            break;
          case DateFilter.last7Days:
            if (difference > 7) return false;
            break;
          case DateFilter.any:
            break;
        }
      }


      if (filter.suitableForDumpTrucks && !app.dumpTrucks) {
        return false;
      }

     
      if (filter.charterCarrier && !app.charter) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> _openFilterScreen() async {
    final result = await context.pushRoute<ApplicationFilter?>(
      FilterRoute(initialFilter: _currentFilter, onFilterApplied: (ApplicationFilter p1) {  }),
    );
    
    if (result != null) {
      _applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayApplications = _currentFilter.hasActiveFilters 
        ? _filteredApplications 
        : _applications;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: BlocConsumer<ApplicationsBloc, ApplicationsState>(
        listener: (context, state) {
          if (state is ApplicationsLoaded) {
            setState(() {
              _applications = state.applications;
              if (_currentFilter.hasActiveFilters) {
                _filteredApplications = _filterApplications(_applications, _currentFilter);
              }
            });
          }
        },
        builder: (context, state) {
          return _buildNestedScrollView(state, displayApplications);
        },
      ),
    );
  }

  Widget _buildNestedScrollView(ApplicationsState state, List<ApplicationModel> displayApplications) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildSliverAppBar(),
        _buildSliverTabBar(),
      ],
      body: _buildTabBarView(state, displayApplications),
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
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.filter_list_alt, 
                color: ColorsConstants.primaryBrownColor, 
                size: 34.0,
              ), 
              onPressed: _openFilterScreen,
            ),
            if (_currentFilter.hasActiveFilters)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                ),
              ),
          ],
        ),
      ], 
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

  Widget _buildTabBarView(ApplicationsState state, List<ApplicationModel> displayApplications) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllApplicationsTab(state, displayApplications), 
        _buildMyResponsesTab()
      ],
    );
  }

  Widget _buildAllApplicationsTab(ApplicationsState state, List<ApplicationModel> displayApplications) {
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
                  child: CircularProgressIndicator(
                    strokeWidth: 4.w,
                    backgroundColor:
                        ColorsConstants.primaryTextFormFieldBackgorundColor,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ),
            )
          else if (displayApplications.isEmpty)
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
                        _currentFilter.hasActiveFilters 
                            ? 'По вашему запросу ничего не найдено'
                            : 'Список доступных заявок пуст',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorsConstants.primaryBrownColorWithOpacity,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_currentFilter.hasActiveFilters)
                        TextButton(
                          onPressed: _openFilterScreen,
                          child: Text(
                            'Изменить фильтры',
                            style: TextStyle(
                              color: ColorsConstants.primaryBrownColor,
                              fontSize: 16.sp,
                            ),
                          ),
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
                    ApplicationCard(application: displayApplications[index]),
                childCount: displayApplications.length,
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