import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/tab_bar_sliver_delegate.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';
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
  ApplicationFilter _currentFilter = ApplicationFilter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(_handleTabChange);
    _loadActiveApplications();
  }

  void _loadActiveApplications() {
    context.read<ApplicationsBloc>().add(
      LoadApplicationsEvent(
        applicationStatus: 'active',
        filter: _currentFilter,
      ),
    );
  }

  void _loadResponses() {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is LoginSuccess ? authState.user.id : null;
    context.read<ApplicationsBloc>().add(LoadResponsesEvent(userId: userId!));
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          _loadActiveApplications();
          break;
        case 1:
          _loadResponses();
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _applyFilter(ApplicationFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    context.read<ApplicationsBloc>().add(
      LoadApplicationsEvent(applicationStatus: 'active', filter: filter),
    );
  }

  void _openFilterScreen() async {
    final result = await AutoRouter.of(
      context,
    ).push(FilterRoute(initialFilter: _currentFilter));

    if (result is ApplicationFilter) {
      _applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstants.primaryBrownColor,
        child: const Icon(
          Icons.map_outlined,
          color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        ),
        onPressed: () {
          context.router.push(MapRoute());
        },
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
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
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.filter_list_alt,
                      color: ColorsConstants.primaryBrownColor,
                      size: 24.0.sp,
                    ),
                    onPressed: _openFilterScreen,
                  ),
                  if (_currentFilter.hasActiveFilters)
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6.w),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 8.w,
                          minHeight: 8.h,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            surfaceTintColor: Colors.transparent,
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: TabBarSliverDelegate(
              tabController: _tabController,
              onTabChanged: _handleTabChange,
              height: 50.h,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            BlocBuilder<ApplicationsBloc, ApplicationsState>(
              builder: (context, state) {
                return RefreshIndicator(
                  color: ColorsConstants.primaryBrownColor,
                  backgroundColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  onRefresh: () async => _loadActiveApplications(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (state is ApplicationsLoading)
                        SliverFillRemaining(
                          child: const PrimaryLoadingIndicator(),
                        )
                      else if (state is ApplicationsLoadingFailure)
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
                                      Icons.error_outline,
                                      size: 40.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Не удалось загрузить заявки',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  TextButton(
                                    onPressed: () => _loadActiveApplications(),
                                    child: Text(
                                      'Повторить',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color:
                                            ColorsConstants.primaryBrownColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else if (state is ApplicationsLoadingSuccess) ...[
                        if (state.applications.isEmpty)
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
                                        color: ColorsConstants
                                            .primaryBrownColorWithOpacity,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      _currentFilter.hasActiveFilters
                                          ? 'По вашему запросу ничего не найдено'
                                          : 'Список доступных заявок пуст',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: ColorsConstants
                                            .primaryBrownColorWithOpacity,
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
                                            color: ColorsConstants
                                                .primaryBrownColor,
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
                          SliverList.builder(
                            itemBuilder: (context, index) {
                              return ApplicationCard(
                                application: state.applications[index],
                                onTap: () => context.router.push(
                                  InfoAboutApplicationRoute(
                                    application: state.applications[index],
                                  ),
                                ),
                              );
                            },
                            itemCount: state.applications.length,
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<ApplicationsBloc, ApplicationsState>(
              builder: (context, state) {
                return RefreshIndicator(
                  color: ColorsConstants.primaryBrownColor,
                  backgroundColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  onRefresh: () async => _loadResponses(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (state is ResponsesLoading)
                        SliverFillRemaining(
                          child: const PrimaryLoadingIndicator(),
                        )
                      else if (state is ResponsesLoadingFailure)
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
                                      Icons.error_outline,
                                      size: 40.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Не удалось загрузить заявки',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  TextButton(
                                    onPressed: () => _loadResponses(),
                                    child: Text(
                                      'Повторить',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color:
                                            ColorsConstants.primaryBrownColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else if (state is ResponsesLoadingSuccess) ...[
                        if (state.applications.isEmpty)
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
                                        color: ColorsConstants
                                            .primaryBrownColorWithOpacity,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      _currentFilter.hasActiveFilters
                                          ? 'По вашему запросу ничего не найдено'
                                          : 'Список заявок с Вашим откликом пуст',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: ColorsConstants
                                            .primaryBrownColorWithOpacity,
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
                                            color: ColorsConstants
                                                .primaryBrownColor,
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
                          SliverList.builder(
                            itemBuilder: (context, index) => ApplicationCard(
                              application: state.applications[index],
                              onTap: () => context.router.push(
                                InfoAboutApplicationMyResponsesRoute(
                                  application: state.applications[index],
                                ),
                              ),
                            ),
                            itemCount: state.applications.length,
                          ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
