import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

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
  List<ApplicationModel> _userActiveApplications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    context.read<UserApplicationsBloc>().add(
      LoadUserApplicationsEvent(applicationStatus: 'active'),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserApplicationsBloc, UserApplicationsState>(
      listener: (context, state) {
        if (state is UserApplicationsLoaded) {
          _userActiveApplications = state.applications;
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorsConstants.backgroundColor,
          body: _buildNestedScrollView(state),
          bottomNavigationBar: _buildCreateApplicationButton(),
        );
      },
    );
  }

  Widget _buildCreateApplicationButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final bool isCustomer = authState is SessionRestored
            ? authState.user.role == 'Заказчик'
            : authState is LoginSuccess
            ? authState.user.role == 'Заказчик'
            : false;

        if (!isCustomer) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: PrimaryButton(
            text: 'Создать заявку',
            onPressed: () =>
                AutoRouter.of(context).push(const CreateApplicationRoute()),
          ),
        );
      },
    );
  }

  Widget _buildNestedScrollView(UserApplicationsState state) {
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
        'Мои заявки',
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

  Widget _buildTabBarView(UserApplicationsState state) {
    return TabBarView(
      controller: _tabController,
      children: [_buildActiveTabContent(state), _buildArchiveTabContent(state)],
    );
  }

  Widget _buildActiveTabContent(UserApplicationsState state) {
    return RefreshIndicator(
      color: ColorsConstants.primaryBrownColor,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      onRefresh: () async {
        context.read<UserApplicationsBloc>().add(
          LoadUserApplicationsEvent(applicationStatus: 'active'),
        );
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (state is UserApplicationsLoading)
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
          else if (state is UserApplicationsLoadingFailure)
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
          else if (_userActiveApplications.isEmpty)
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
                        'Список Ваших активных заявок пуст',
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
                (context, index) => ApplicationCard(
                  application: _userActiveApplications[index],
                ),
                childCount: _userActiveApplications.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildArchiveTabContent(UserApplicationsState state) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CustomScrollView(
        slivers: [
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
                        color:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.archive_outlined,
                        size: 40.sp,
                        color: ColorsConstants.primaryBrownColorWithOpacity,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Список Ваших архивных заявок пуст',
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
          Tab(text: 'Активные'),
          Tab(text: 'Архив'),
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
