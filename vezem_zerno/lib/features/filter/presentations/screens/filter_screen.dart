import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_divider.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';
import 'package:vezem_zerno/features/filter/presentations/screens/widgets/date_chip.dart';
import 'package:vezem_zerno/features/filter/presentations/screens/widgets/number_field.dart';

@RoutePage()
class FilterScreen extends StatefulWidget {
  final ApplicationFilter initialFilter;

  const FilterScreen({super.key, required this.initialFilter});

  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  late ApplicationFilter _currentFilter;

  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _minDistanceController;
  late final TextEditingController _maxDistanceController;

  late final TextEditingController _loadingRegionController;
  late final TextEditingController _unloadingRegionController;
  late final TextEditingController _cropController;

  final Map<String, List<String>> _demoData = {
    'Регион': [
      'Московская область',
      'Ленинградская область',
      'Краснодарский край',
      'Ростовская область',
      'Воронежская область',
    ],
    'Культура': [
      'Пшеница',
      'Ячмень',
      'Кукуруза',
      'Подсолнечник',
      'Рапс',
      'Горох',
    ],
  };

  @override
  void initState() {
    super.initState();

    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _minDistanceController = TextEditingController();
    _maxDistanceController = TextEditingController();
    _loadingRegionController = TextEditingController();
    _unloadingRegionController = TextEditingController();
    _cropController = TextEditingController();

    _currentFilter = widget.initialFilter.copyWith();
    _updateControllers();
  }

  void _updateControllers() {
    _minPriceController.text = _currentFilter.minPrice?.toString() ?? '';
    _maxPriceController.text = _currentFilter.maxPrice?.toString() ?? '';
    _minDistanceController.text = _currentFilter.minDistance?.toString() ?? '';
    _maxDistanceController.text = _currentFilter.maxDistance?.toString() ?? '';
    _loadingRegionController.text = _currentFilter.loadingRegion ?? '';
    _unloadingRegionController.text = _currentFilter.unloadingRegion ?? '';
    _cropController.text = _currentFilter.crop ?? '';
  }

  void _updateSelectionField(TextEditingController controller, String? value) {
    controller.text = value ?? '';
  }

  double? _parseNumber(String text) {
    if (text.isEmpty) return null;
    final cleanText = text.replaceAll(',', '.');
    return double.tryParse(cleanText);
  }

  void _applyFilter() {
    final minPrice = _parseNumber(_minPriceController.text);
    final maxPrice = _parseNumber(_maxPriceController.text);
    final minDistance = _parseNumber(_minDistanceController.text);
    final maxDistance = _parseNumber(_maxDistanceController.text);

    final updatedFilter = _currentFilter.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minDistance: minDistance,
      maxDistance: maxDistance,
    );

    context.pop(updatedFilter);
  }

  void _resetFilter() {
    setState(() {
      _currentFilter = ApplicationFilter();
      _updateControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        title: Text(
          'Фильтры',
          style: TextStyle(
            fontSize: 20.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _resetFilter,
            child: Text(
              'Сбросить',
              style: TextStyle(
                color: ColorsConstants.primaryBrownColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryTextFormField(
              readOnly: true,
              controller: _loadingRegionController,
              labelText: 'Регион погрузки',
              onTap: () => _showSelectionDialog('Регион', (value) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    loadingRegion: value,
                  );
                  _updateSelectionField(_loadingRegionController, value);
                });
              }),
            ),
            SizedBox(height: 16.h),
            PrimaryTextFormField(
              readOnly: true,
              controller: _unloadingRegionController,
              labelText: 'Регион выгрузки',
              onTap: () => _showSelectionDialog('Регион', (value) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    unloadingRegion: value,
                  );
                  _updateSelectionField(_unloadingRegionController, value);
                });
              }),
            ),
            SizedBox(height: 16.h),
            PrimaryTextFormField(
              readOnly: true,
              controller: _cropController,
              labelText: 'Культура',
              onTap: () => _showSelectionDialog('Культура', (value) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(crop: value);
                  _updateSelectionField(_cropController, value);
                });
              }),
            ),

            SizedBox(height: 16.h),
            const PrimaryDivider(),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Цена, ₽/кг',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: NumberField(
                        controller: _minPriceController,
                        hintText: 'От',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: NumberField(
                        controller: _maxPriceController,
                        hintText: 'До',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            const PrimaryDivider(),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Расстояние, км',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: NumberField(
                        controller: _minDistanceController,
                        hintText: 'От',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: NumberField(
                        controller: _minDistanceController,
                        hintText: 'До',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            const PrimaryDivider(),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Дата публикации',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstants.primaryBrownColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    DateChip(
                      label: 'Любая',
                      value: DateFilter.any,
                      isSelected: _currentFilter.dateFilter == DateFilter.any,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _currentFilter = _currentFilter.copyWith(
                              dateFilter: DateFilter.any,
                            );
                          }
                        });
                      },
                    ),
                    DateChip(
                      label: 'За 3 дня',
                      value: DateFilter.last3Days,
                      isSelected:
                          _currentFilter.dateFilter == DateFilter.last3Days,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _currentFilter = _currentFilter.copyWith(
                              dateFilter: DateFilter.last3Days,
                            );
                          }
                        });
                      },
                    ),
                    DateChip(
                      label: 'За 5 дней',
                      value: DateFilter.last5Days,
                      isSelected:
                          _currentFilter.dateFilter == DateFilter.last5Days,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _currentFilter = _currentFilter.copyWith(
                              dateFilter: DateFilter.last5Days,
                            );
                          }
                        });
                      },
                    ),
                    DateChip(
                      label: 'За 7 дней',
                      value: DateFilter.last7Days,
                      isSelected:
                          _currentFilter.dateFilter == DateFilter.last7Days,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _currentFilter = _currentFilter.copyWith(
                              dateFilter: DateFilter.last7Days,
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            const PrimaryDivider(),
            SizedBox(height: 24.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _currentFilter.suitableForDumpTrucks,
                        onChanged: (value) {
                          setState(() {
                            _currentFilter = _currentFilter.copyWith(
                              suitableForDumpTrucks: value ?? false,
                            );
                          });
                        },
                        activeColor: ColorsConstants.primaryBrownColor,
                        checkColor:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Подходят самосвалы',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsConstants.primaryBrownColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _currentFilter.charterCarrier,
                        onChanged: (value) {
                          setState(() {
                            _currentFilter = _currentFilter.copyWith(
                              charterCarrier: value ?? false,
                            );
                          });
                        },
                        activeColor: ColorsConstants.primaryBrownColor,
                        checkColor:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Перевозчик работает по хартии',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsConstants.primaryBrownColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),
            PrimaryButton(text: 'Показать заявки', onPressed: _applyFilter),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  void _showSelectionDialog(String title, Function(String) onSelected) {
    final items = _demoData[title] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        title: Text(
          title,
          style: TextStyle(
            color: ColorsConstants.primaryBrownColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                  child: ListTile(
                    title: Text(
                      'Не выбрано',
                      style: TextStyle(
                        color: ColorsConstants.primaryBrownColorWithOpacity,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      onSelected('');
                      context.router.pop();
                    },
                  ),
                );
              }

              final item = items[index - 1];
              return Container(
                color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                child: ListTile(
                  title: Text(
                    item,
                    style: TextStyle(
                      color: ColorsConstants.primaryBrownColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    onSelected(item);
                    context.router.pop();
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.pop(),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: ColorsConstants.primaryBrownColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loadingRegionController.dispose();
    _unloadingRegionController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minDistanceController.dispose();
    _maxDistanceController.dispose();
    _cropController.dispose();
    super.dispose();
  }
}
