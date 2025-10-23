import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

@RoutePage()
class InfoAboutApplicationScreen extends StatefulWidget {
  final ApplicationModel application;

  const InfoAboutApplicationScreen({super.key, required this.application});

  @override
  State<InfoAboutApplicationScreen> createState() =>
      _InfoAboutApplicationScreenState();
}

class _InfoAboutApplicationScreenState extends State<InfoAboutApplicationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Изменить на 3 когда будут готовы остальные вкладки
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Заявка',
          style: TextStyle(
            fontSize: 20.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        foregroundColor: ColorsConstants.primaryBrownColor,
      ),
      body: Column(
        children: [
          // Раскомментировать когда будут готовы остальные вкладки
          /*
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue[700],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue[700],
              tabs: const [
                Tab(text: 'Информация'),
                // Tab(text: 'Отзывы'),
                // Tab(text: 'Диалог'),
              ],
            ),
          ),
          */
          Expanded(
            child:
                // Раскомментировать когда будут готовы остальные вкладки
                // TabBarView(
                //   controller: _tabController,
                //   children: [
                _buildInfoTab(),
            // _buildReviewsTab(),
            // _buildDialogueTab(),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Основная информация
          _buildInfoCard('Основная информация', [
            _buildInfoRow('Культура', widget.application.crop),
            _buildInfoRow('Объем перевозки', '${widget.application.tonnage} т'),
            _buildInfoRow('Цена', '${widget.application.price} ₽/кг'),
            _buildInfoRow('Расстояние', '${widget.application.distance} км'),
            _buildInfoRow(
              'Дата создания',
              _formatDate(widget.application.createdAt),
            ),
          ]),
          SizedBox(height: 16.h),

          // Маршрут
          _buildInfoCard('Маршрут', [
            _buildLocationRow('Погрузка', widget.application.loadingPlace),
            _buildLocationRow('Выгрузка', widget.application.unloadingPlace),
          ]),
          SizedBox(height: 16.h),

          // Условия погрузки
          _buildInfoCard('Условия погрузки', [
            _buildInfoRow('Способ погрузки', widget.application.loadingMethod),
            _buildInfoRow(
              'Грузоподъемность весов',
              '${widget.application.scalesCapacity} т',
            ),
            _buildInfoRow('Дата погрузки', widget.application.loadingDate),
          ]),
          SizedBox(height: 16.h),

          // Детали перевозки
          _buildInfoCard('Детали перевозки', [
            _buildInfoRow('Простой', widget.application.downtime),
            _buildInfoRow(
              'Допустимая недостача',
              '${widget.application.shortage} кг',
            ),
            _buildInfoRow('Вид оплаты', widget.application.paymentMethod),
            _buildInfoRow(
              'Сроки оплаты',
              widget.application.paymentTerms,
            ),
            _buildInfoRow(
              'Самосвалы',
              widget.application.dumpTrucks ? 'Да' : 'Нет',
            ),
            _buildInfoRow(
              'Перевозчик работает по хартии',
              widget.application.charter ? 'Да' : 'Нет',
            ),
          ]),
          const SizedBox(height: 16),

          // Заказчик
          _buildInfoCard('Заказчик', [
            _buildInfoRow('Организация', widget.application.organization),
          ]),
          SizedBox(height: 16.h),

          // Комментарий
          if (widget.application.comment.isNotEmpty)
            _buildInfoCard('Комментарий', [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  widget.application.comment,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
              ),
            ]),
        ],
      ),
    );
  }

  // Раскомментировать когда будем делать вкладку отзывов
  /*
  Widget _buildReviewsTab() {
    return const Center(
      child: Text(
        'Раздел отзывов\n(не реализовано)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
  */

  // Раскомментировать когда будем делать вкладку диалога
  /*
  Widget _buildDialogueTab() {
    return const Center(
      child: Text(
        'Раздел диалога\n(не реализовано)',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
  */

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      color: ColorsConstants.primaryTextFormFieldBackgorundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            SizedBox(height: 8.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        spacing: 12.w,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color.fromARGB(134, 66, 44, 26),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String type, String location) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            margin: EdgeInsets.only(right: 12.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: type == 'Погрузка' ? Colors.blue : Colors.red,
                width: 2.w,
              ),
            ),
            child: Icon(Icons.circle, size: 8.sp, color: type == 'Погрузка' ? Colors.blue : Colors.red),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromARGB(134, 66, 44, 26),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Не указана';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
