import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/features/user_applications/data/models/application_model.dart';

@RoutePage()
class InfoAboutApplicationScreen extends StatefulWidget {
  const InfoAboutApplicationScreen({
    Key? key,
    required this.application,
  }) : super(key: key);

  final ApplicationModel application; 

  @override
  State<InfoAboutApplicationScreen> createState() => _InfoAboutApplicationScreenState();
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
        title: Text('Заявка ${widget.application.organization}', 
          style: TextStyle(
          fontSize: 20,
          color: ColorsConstants.primaryBrownColor,
          fontWeight: FontWeight.w500,
        ),),
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        foregroundColor: ColorsConstants.primaryBrownColor,
        elevation: 0,
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
          _buildInfoCard(
            'Основная информация',
            [
              _buildInfoRow('Культура', widget.application.crop),
              _buildInfoRow('Объем перевозки', '${widget.application.tonnage} т'),
              _buildInfoRow('Цена', '${widget.application.price} ₽/кг'),
              _buildInfoRow('Расстояние', '${widget.application.distance} км'),
              _buildInfoRow('Статус', _getStatusText(widget.application.status)),
              _buildInfoRow('Дата создания', _formatDate(widget.application.createdAt)),
            ],
          ),
          const SizedBox(height: 16),

          // Маршрут
          _buildInfoCard(
            'Маршрут',
            [
              _buildLocationRow('Погрузка', widget.application.loadingPlace),
              _buildLocationRow('Выгрузка', widget.application.unloadingPlace),
            ],
          ),
          const SizedBox(height: 16),

          // Условия погрузки
          _buildInfoCard(
            'Условия погрузки',
            [
              _buildInfoRow('Способ погрузки', widget.application.loadingMethod),
              _buildInfoRow('Грузоподъемность весов', '${widget.application.scalesCapacity} т'),
              _buildInfoRow('Дата погрузки', widget.application.loadingDate),
            ],
          ),
          const SizedBox(height: 16),

          // Детали перевозки
          _buildInfoCard(
            'Детали перевозки',
            [
              _buildInfoRow('Простой', '${widget.application.downtime} дней'),
              _buildInfoRow('Допустимая недостача', '${widget.application.shortage} кг'),
              _buildInfoRow('Вид оплаты', widget.application.paymentMethod),
              _buildInfoRow('Сроки оплаты', '${widget.application.paymentTerms} дней'),
              _buildInfoRow('Самосвалы', widget.application.dumpTrucks ? 'Да' : 'Нет'),
              _buildInfoRow('Чартер', widget.application.charter ? 'Да' : 'Нет'),
            ],
          ),
          const SizedBox(height: 16),

          // Заказчик
          _buildInfoCard(
            'Заказчик',
            [
              _buildInfoRow('Организация', widget.application.organization),
            ],
          ),
          const SizedBox(height: 16),

          // Комментарий
          if (widget.application.comment.isNotEmpty)
            _buildInfoCard(
              'Комментарий',
              [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.application.comment,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(String type, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Icon(
              Icons.circle,
              size: 8,
              color: Colors.blue[700],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
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

  String _getStatusText(String status) {
    switch (status) {
      case 'draft':
        return 'Черновик';
      case 'published':
        return 'Опубликована';
      case 'in_progress':
        return 'В работе';
      case 'completed':
        return 'Завершена';
      case 'cancelled':
        return 'Отменена';
      default:
        return status;
    }
  }
}