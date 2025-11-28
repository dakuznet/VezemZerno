import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/tab_bar_sliver_delegate.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/applications_list_content.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class UserApplicationsListScreen extends StatefulWidget {
  const UserApplicationsListScreen({super.key});

  @override
  State<UserApplicationsListScreen> createState() =>
      _UserApplicationsListScreenState();
}

class _UserApplicationsListScreenState extends State<UserApplicationsListScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _tabCount = 3;

  late TabController _tabController;
  final Map<String, List<ApplicationEntity>> _applicationsByStatus = {
    'active': [],
    'processing': [],
    'completed': [],
  };

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

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final userId = _getCurrentUserId();
      switch (_tabController.index) {
        case 0:
          context.read<UserApplicationsBloc>().add(
            LoadUserApplicationsEvent(
              status: _getStatusForTabIndex(0),
              userId: userId!,
            ),
          );
          break;
        case 1:
          context.read<UserApplicationsBloc>().add(
            LoadUserApplicationsEvent(
              status: _getStatusForTabIndex(1),
              userId: userId!,
            ),
          );
          break;
        case 2:
          context.read<UserApplicationsBloc>().add(
            LoadUserApplicationsEvent(
              status: _getStatusForTabIndex(2),
              userId: userId!,
            ),
          );
          break;
      }
    }
  }

  String? _getCurrentUserId() {
    final authState = context.read<AuthBloc>().state;
    return authState is LoginSuccess ? authState.user.id : null;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _loadActiveApplications() {
    final userId = _getCurrentUserId();
    context.read<UserApplicationsBloc>().add(
      LoadUserApplicationsEvent(status: 'active', userId: userId!),
    );
  }

  String _getStatusForTabIndex(int index) {
    switch (index) {
      case 0:
        return 'active';
      case 1:
        return 'processing';
      case 2:
        return 'completed';
      default:
        return 'active';
    }
  }

  void _refreshStatus(String status) {
    final userId = _getCurrentUserId();
    context.read<UserApplicationsBloc>().add(
      LoadUserApplicationsEvent(status: status, userId: userId!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserApplicationsBloc, UserApplicationsState>(
      listener: (context, state) {
        if (state is UserApplicationsLoadSuccess) {
          setState(() {
            _applicationsByStatus[state.status] = state.applications;
          });
        }
      },
      child: Scaffold(
        backgroundColor: ColorsConstants.backgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor:
                  ColorsConstants.primaryTextFormFieldBackgorundColor,
              surfaceTintColor: Colors.transparent,
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
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarSliverDelegate(
                tabController: _tabController,
                height:
                    (50 * MediaQuery.of(context).devicePixelRatio).round() /
                    MediaQuery.of(context).devicePixelRatio,
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              ApplicationsListContent(
                applications: _applicationsByStatus['active'] ?? [],
                onRefresh: () => _refreshStatus('active'),
                status: 'active',
              ),
              ApplicationsListContent(
                applications: _applicationsByStatus['processing'] ?? [],
                onRefresh: () => _refreshStatus('processing'),
                status: 'processing',
              ),
              ApplicationsListContent(
                applications: _applicationsByStatus['completed'] ?? [],
                onRefresh: () => _refreshStatus('completed'),
                status: 'completed',
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
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
                    context.router.push(const CreateApplicationRoute()),
              ),
            );
          },
        ),
      ),
    );
  }
}
