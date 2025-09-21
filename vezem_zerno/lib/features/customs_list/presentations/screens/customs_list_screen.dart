import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

@RoutePage()
class CustomsListScreen extends StatefulWidget {
  const CustomsListScreen({super.key});

@override
  State<CustomsListScreen> createState() => _CustomsListScreenState();
}

class _CustomsListScreenState extends State<CustomsListScreen> {
  int _selectedTab = 0; // 0 - Активные, 1 - История

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(''), // Пустой заголовок
            expandedHeight: 150.0.h,
            pinned: true,
            floating: false,
            snap: false,
            backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15.0),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: ColorsConstants.primaryBrownColor,
                    size: 28.sp,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final expandedHeight = 150.0.h;
                final currentHeight = constraints.maxHeight;
                final collapseFactor = 1 - (currentHeight / expandedHeight);
                final topPadding = MediaQuery.of(context).padding.top;
                
                return Stack(
                  children: [
                    // Фон
                    Container(
                      decoration: BoxDecoration(
                        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(15.0),
                        ),
                      ),
                    ),
                    
                    // Заголовок по центру сверху
                    Positioned(
                      top: topPadding + 10.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Мои заявки',
                          style: TextStyle(
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w500,
                            fontSize: 25.sp,
                            color: ColorsConstants.primaryBrownColor,
                          ),
                        ),
                      ),
                    ),
                    
                    // Кнопки-табы (скрываются при скролле)
                    Positioned(
                      bottom: 20.h,
                      left: 0,
                      right: 0,
                      child: Opacity(
                        opacity: 1 - collapseFactor.clamp(0.0, 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Таб "Активные"
                            GestureDetector(
                              onTap: () => setState(() => _selectedTab = 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _selectedTab == 0 
                                        ? ColorsConstants.primaryBrownColor 
                                        : Colors.transparent, // Прозрачный когда неактивен
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Активные',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: _selectedTab == 0 
                                      ? ColorsConstants.primaryBrownColor 
                                      : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(width: 32.w),
                            
                            // Таб "История"
                            GestureDetector(
                              onTap: () => setState(() => _selectedTab = 1),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _selectedTab == 1 
                                        ? ColorsConstants.primaryBrownColor 
                                        : Colors.transparent, // Прозрачный когда неактивен
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'История',
                                  style: TextStyle(
                                    fontFamily: 'Unbounded',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: _selectedTab == 1 
                                      ? ColorsConstants.primaryBrownColor 
                                      : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Контент (остается одинаковым для обоих табов)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(
                    _selectedTab == 0 
                      ? 'У вас нет ни одной активной заявки' 
                      : 'У вас нет истории заявок',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsConstants.primaryBrownColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      _selectedTab == 0 ? 'Создать заявку' : 'Посмотреть архив',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}