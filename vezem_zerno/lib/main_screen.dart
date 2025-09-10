import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/bottom_navigation_bar.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [CustomsListRoute(), MapRoute(), ProfileRoute()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: ColorsConstants.backgroundColor,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: child,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
