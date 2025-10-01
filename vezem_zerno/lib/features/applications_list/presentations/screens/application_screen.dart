import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/application_entiry.dart';
import 'package:vezem_zerno/features/applications_list/presentations/screens/widgets/application_card_widget.dart';

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
  final List<ApplicationEntity> _applications = _generateSampleApplications();

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
      children: [_buildAllApplicationsTab(), _buildMyResponsesTab()],
    );
  }

  Widget _buildAllApplicationsTab() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                ApplicationCard(application: _applications[index]),
            childCount: _applications.length,
          ),
        ),
      ],
    );
  }

  Widget _buildMyResponsesTab() {
    return const CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: Text('Заявки с вашими откликами появятся здесь'),
          ),
        ),
      ],
    );
  }

  static List<ApplicationEntity> _generateSampleApplications() {
    return [
      ApplicationEntity(
        customer: "ООО Порт Транзит Экспедирование",
        date: '24.09.2025',
        from: 'с. Труновское, Ставропольский край',
        to: 'КСК, Краснодарский край',
        cargo: 'Ячмень',
        weight: '300 тонн',
        distance: '1130 км',
        tariff: "5 ₽/кг",
      ),
      ApplicationEntity(
        customer: "ООО ГТЭ-Транспорт",
        date: '24.09.2025',
        from: 'с. Подсосёнки, Саратовская область',
        to: 'с. Тбилисская, Краснодарский край',
        cargo: 'Соя',
        weight: '300 тонн',
        distance: '1170 км',
        tariff: "2.15 ₽/кг",
      ),
      ApplicationEntity(
        customer: "ООО Порт Транзит Экспедирование",
        date: '28.09.2025',
        from: 'п. Комсомолец, Ставропольский край',
        to: 'НКХП, г. Новороссийск',
        cargo: 'Ячмень',
        weight: '800 тонн',
        distance: '600 км',
        tariff: "4.5 ₽/кг",
      ),
    ];
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
      // Используем явно заданную высоту
      height: height,
      child: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: 'Все заявки'),
          Tab(text: 'С моим откликом'),
        ],
        labelColor: ColorsConstants.primaryBrownColor,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w500,
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
