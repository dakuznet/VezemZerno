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

class _ApplicationScreenState extends State<ApplicationScreen>  with SingleTickerProviderStateMixin{

    late TabController _tabController;
    int _currentBottomIndex = 0;

   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Application> _applications = [
    Application(
      number: 'Заявка №1',
      date: '01.10.09 2025',
      status: 'Подробнее',
      from: 'г. Ростов-на-Дону',
      to: 'г. Краснодар',
      cargo: 'Пшеница',
      weight: '20000 тонн',
      size: '250 км',
    ),
    Application(
      number: 'Заявка №2',
      date: '01.10.09 2025',
      status: 'Подробнее',
      from: 'г. Караганда',
      to: 'г. Батайск',
      cargo: 'Ячмень',
      weight: '15000 тонн',
      size: '999 км',
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        elevation: 0,
        title: Text(
          'Заявки', 
          style: TextStyle(fontSize: 16.sp, color: ColorsConstants.primaryBrownColor, fontFamily: 'Unbounded',fontWeight: FontWeight.w500,),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController, 
            tabs: [
              Tab(text: 'Все заявки',), 
              Tab(text: 'С моим откликом',)
              ], 
              labelColor: ColorsConstants.primaryBrownColor, 
              labelStyle: TextStyle(
                fontSize: 14.sp, 
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.w500,
                color: ColorsConstants.primaryBrownColor),
          indicatorColor: const Color.fromARGB(255, 0, 0, 0),
  ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsConstants.backgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: _applications.length,
            itemBuilder: (context,index) { return ApplicationCard(application: _applications[index]);},
          ),
          const Center(
            child: Text('Заявки с вашими откликами появятся здесь'),
          ),
        ],
        )
    );
  }
}

class Application {
  final String number;
  final String date;
  final String status;
  final String from;
  final String to;
  final String cargo;
  final String weight;
  final String size;

  Application({
    required this.number,
    required this.date,
    required this.status,
    required this.from,
    required this.to,
    required this.cargo,
    required this.weight,
    required this.size,
  });
}

class ApplicationCard extends StatelessWidget {
  final Application application;

  const ApplicationCard({Key? key, required this.application}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(35.0), ),
      color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              application.number,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color:  ColorsConstants.primaryBrownColor,
                fontFamily: "Unbounded"
              ),
            ),
            // Дата и статус
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(application.date, 
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp,
                  color: ColorsConstants.primaryBrownColorWithOpacity,
                  ),
                ),
                Text(
                  application.status,
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ],
            ),
            
            Divider( height: 16,
      thickness: 1,
      color: ColorsConstants.primaryBrownColor),
            SizedBox(height: 16.h),
            
            // Откуда и куда
           Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text.rich(
      TextSpan(
        text: 'Откуда:  ',
        style: TextStyle(
          fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorsConstants.primaryBrownColor,
        ),
        children: [
          TextSpan(
            text: application.from,
            style: TextStyle(
              fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ],
      ),
    ),
    

    SizedBox(height: 8),
    

    if (application.to.isNotEmpty)
      Text.rich(
        TextSpan(
          text: 'Куда:  ',
          style: TextStyle(
            fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorsConstants.primaryBrownColor,
          ),
          children: [
            TextSpan(
              text: application.to,
              style: TextStyle(
                fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: ColorsConstants.primaryBrownColor,
              ),
            ),
          ],
        ),
      ),
  ],
),
            SizedBox(height: 16.h),
            // Информация о грузе
            if (application.cargo.isNotEmpty)
              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Овал 1
    Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsConstants.primaryBrownColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: EdgeInsets.only(right: 8), // Отступ справа
      child: Text(
        application.cargo,
        style: TextStyle(
          fontSize: 11.sp,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.bold, 
          color: ColorsConstants.primaryBrownColor,
        ),
      ),
    ),
    
    // Овал 2
    if (application.weight.isNotEmpty)
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsConstants.primaryBrownColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 8), // Отступы слева и справа
        child: Text(
          application.weight,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.bold, 
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ),
    
    // Овал 3
    if (application.size.isNotEmpty)
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsConstants.primaryBrownColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        margin: EdgeInsets.only(left: 8), // Отступ слева
        child: Text(
          application.size,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.bold, 
            color: ColorsConstants.primaryBrownColor,
          ),
        ),
      ),
  ],
),
            SizedBox(height: 16.h),
            
            Divider( height: 16,
          thickness: 1,
          color: ColorsConstants.primaryBrownColor),
            SizedBox(height: 16.h),
            
            // Кнопка отклика
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstants.primaryButtonBackgroundColor
                ),
                onPressed: () {},
                child: Text(
                  'Откликнуться', 
                  style: TextStyle(
                    fontFamily: 'Unbounded',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorsConstants.primaryBrownColor,),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}