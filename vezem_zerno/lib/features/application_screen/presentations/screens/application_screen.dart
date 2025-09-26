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
          style: TextStyle(fontSize: 18.sp, color: ColorsConstants.primaryBrownColor,),
          ),
          centerTitle: true,
          bottom: TabBar(controller: _tabController, tabs: [Tab(text: 'Все заявки',), Tab(text: 'С моим откликом',)],          labelColor: Colors.black,
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
                fontWeight: FontWeight.bold,
                color:  ColorsConstants.primaryBrownColor
              ),
            ),
            SizedBox(height: 8.h),
            // Дата и статус
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(application.date, style: TextStyle(fontWeight: FontWeight.normal,color: ColorsConstants.primaryBrownColorWithOpacity,),),
                Text(
                  application.status,
                  style: TextStyle(
                    color: ColorsConstants.primaryBrownColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Разделитель
            Divider( height: 16,
      thickness: 1,
      color: ColorsConstants.primaryBrownColor),
            SizedBox(height: 16.h),
            
            // Откуда и куда
           Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Строка "Откуда"
    Text.rich(
      TextSpan(
        text: 'Откуда: ',
        style: TextStyle(
          fontWeight: FontWeight.normal, 
          color: ColorsConstants.primaryBrownColorWithOpacity
        ),
        children: [
          TextSpan(
            text: application.from,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorsConstants.primaryBrownColor
            ),
          ),
        ],
      ),
    ),
    
    // Добавляем отступ между строками
    SizedBox(height: 8),
    
    // Строка "Куда" (если есть значение)
    if (application.to.isNotEmpty)
      Text.rich(
        TextSpan(
          text: 'Куда: ',
          style: TextStyle(
            fontWeight: FontWeight.normal, 
            color: ColorsConstants.primaryBrownColorWithOpacity
          ),
          children: [
            TextSpan(
              text: application.to,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsConstants.primaryBrownColor
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
              Text.rich(
                TextSpan(
                  text: application.cargo,
                  style: TextStyle(fontWeight: FontWeight.bold, color: ColorsConstants.primaryBrownColor),
                  children: [
                    if (application.weight.isNotEmpty)
                      TextSpan(
                        text: ' ${application.weight}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorsConstants.primaryBrownColor),
                      ),
                    if (application.size.isNotEmpty)
                      TextSpan(
                        text: ' ${application.size}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorsConstants.primaryBrownColor),
                      ),
                  ],
                ),
              ),
            SizedBox(height: 16.h),
            
            // Разделитель
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
                child: Text('Откликнуться', style: TextStyle(color: ColorsConstants.primaryBrownColor,fontWeight: FontWeight.bold ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}