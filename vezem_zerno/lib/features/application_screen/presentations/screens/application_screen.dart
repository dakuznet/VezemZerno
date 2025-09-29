import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

@RoutePage()
class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 2;

  late final TabController _tabController;
  final List<Application> _applications = _generateSampleApplications();

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
      delegate: _TabBarSliverDelegate(tabController: _tabController),
    );
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

  static List<Application> _generateSampleApplications() {
    return [
      Application(
        customer: "ООО Порт Транзит Экспедирование",
        date: '24.09.2025',
        from: 'с. Труновское, Ставропольский край',
        to: 'КСК, Краснодарский край',
        cargo: 'Ячмень',
        weight: '300 тонн',
        distance: '1130 км',
        tariff: "5 ₽/кг",
      ),
      Application(
        customer: "ООО ГТЭ-Транспорт",
        date: '24.09.2025',
        from: 'с. Подсосёнки, Саратовская область',
        to: 'с. Тбилисская, Краснодарский край',
        cargo: 'Соя',
        weight: '300 тонн',
        distance: '1170 км',
        tariff: "2.15 ₽/кг",
      ),
      Application(
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

  _TabBarSliverDelegate({required this.tabController});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: ColorsConstants.primaryTextFormFieldBackgorundColor,
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
      ),
    );
  }

  @override
  double get maxExtent => 48.h;

  @override
  double get minExtent => 48.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class Application {
  final String date;
  final String from;
  final String to;
  final String cargo;
  final String weight;
  final String distance;
  final String customer;
  final String tariff;

  const Application({
    required this.customer,
    required this.date,
    required this.from,
    required this.to,
    required this.cargo,
    required this.weight,
    required this.distance,
    required this.tariff,
  });
}

class ApplicationCard extends StatelessWidget {
  final Application application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.sp,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),
            _buildDivider(),
            _buildLocationWithTariff(),
            SizedBox(height: 16.h),
            _buildCargoInfo(),
            _buildDivider(),
            _buildCustomerInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Опубликовано ${application.date}",
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: const Color.fromARGB(172, 66, 44, 26),
          ),
        ),
        Icon(
          Icons.arrow_circle_right_outlined,
          size: 24.sp,
          color: ColorsConstants.primaryBrownColor,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Divider(
        height: 2.h,
        color: ColorsConstants.primaryBrownColorWithOpacity,
      ),
    );
  }

  Widget _buildLocationWithTariff() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildLocationInfo()),
        SizedBox(width: 16.w),
        _buildTariffChip(),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationRow(label: 'Откуда:', value: application.from),
        if (application.to.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _buildLocationRow(label: 'Куда:', value: application.to),
        ],
      ],
    );
  }

  Widget _buildLocationRow({required String label, required String value}) {
    return Text.rich(
      TextSpan(
        text: '$label ',
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: const Color.fromARGB(172, 66, 44, 26),
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTariffChip() {
    return Text(
      application.tariff,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Unbounded',
        fontWeight: FontWeight.w600,
        color: ColorsConstants.primaryBrownColor,
      ),
    );
  }

  Widget _buildCargoInfo() {
    final List<Widget> cargoChips = [];

    if (application.cargo.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.cargo));
    }

    if (application.weight.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.weight));
    }

    if (application.distance.isNotEmpty) {
      cargoChips.add(_buildCargoChip(application.distance));
    }

    return Wrap(spacing: 8.w, runSpacing: 8.h, children: cargoChips);
  }

  Widget _buildCargoChip(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsConstants.primaryBrownColor,
          width: 2.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w700,
          color: ColorsConstants.primaryBrownColor,
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Заказчик",
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: const Color.fromARGB(172, 66, 44, 26),
          ),
        ),
        Text(
          application.customer,
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ],
    );
  }
}
