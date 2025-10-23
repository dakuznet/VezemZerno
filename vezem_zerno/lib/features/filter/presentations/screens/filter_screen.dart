import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/filter/data/models/application_filter_model.dart';

@RoutePage()
class FilterScreen extends StatefulWidget {
  final ApplicationFilter initialFilter;

  const FilterScreen({Key? key, required this.initialFilter}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late ApplicationFilter _currentFilter;

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minDistanceController = TextEditingController();
  final TextEditingController _maxDistanceController = TextEditingController();

  final TextEditingController _loadingRegionController =
      TextEditingController();
  final TextEditingController _loadingDistrictController =
      TextEditingController();
  final TextEditingController _unloadingRegionController =
      TextEditingController();
  final TextEditingController _unloadingDistrictController =
      TextEditingController();
  final TextEditingController _cropController = TextEditingController();

  final Map<String, List<String>> _demoData = {
    'Регион погрузки': [
      'Московская область',
      'Ленинградская область',
      'Краснодарский край',
      'Ростовская область',
      'Воронежская область',
    ],
    'Район погрузки': [
      'Центральный район',
      'Северный район',
      'Южный район',
      'Восточный район',
      'Западный район',
    ],
    'Регион выгрузки': [
      'Московская область',
      'Ленинградская область',
      'Краснодарский край',
      'Ростовская область',
      'Воронежская область',
    ],
    'Район выгрузки': [
      'Центральный район',
      'Северный район',
      'Южный район',
      'Восточный район',
      'Западный район',
    ],
    'Культура': [
      'Пшеница',
      'Ячмень',
      'Кукуруза',
      'Подсолнечник',
      'Рапс',
      'Соја',
      'Горох',
    ],
  };

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter.copyWith();
    _updateControllers();
  }

  void _updateControllers() {
    _minPriceController.text = _currentFilter.minPrice?.toString() ?? '';
    _maxPriceController.text = _currentFilter.maxPrice?.toString() ?? '';
    _minDistanceController.text = _currentFilter.minDistance?.toString() ?? '';
    _maxDistanceController.text = _currentFilter.maxDistance?.toString() ?? '';

    _loadingRegionController.text = _currentFilter.loadingRegion ?? '';
    _loadingDistrictController.text = _currentFilter.loadingDistrict ?? '';
    _unloadingRegionController.text = _currentFilter.unloadingRegion ?? '';
    _unloadingDistrictController.text = _currentFilter.unloadingDistrict ?? '';
    _cropController.text = _currentFilter.crop ?? '';
  }

  void _updateSelectionField(TextEditingController controller, String? value) {
    controller.text = value ?? '';
  }

  void _applyFilter() {
    final updatedFilter = _currentFilter.copyWith(
      minPrice: double.tryParse(_minPriceController.text),
      maxPrice: double.tryParse(_maxPriceController.text),
      minDistance: double.tryParse(_minDistanceController.text),
      maxDistance: double.tryParse(_maxDistanceController.text),
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
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        foregroundColor: ColorsConstants.primaryBrownColor,
        elevation: 0,
        title: Text(
          'Фильтры',
          style: TextStyle(
            fontSize: 18.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'Unbounded',
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _resetFilter,
            child: Text(
              'Сбросить',
              style: TextStyle(
                color: ColorsConstants.primaryBrownColorWithOpacity,
                fontSize: 14.sp,
                fontFamily: 'Unbounded',
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
              onTap: () => _showSelectionDialog('Регион погрузки', (value) {
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
              controller: _loadingDistrictController,
              labelText: 'Район погрузки',
              onTap: () => _showSelectionDialog('Район погрузки', (value) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    loadingDistrict: value,
                  );
                  _updateSelectionField(_loadingDistrictController, value);
                });
              }),
            ),
            SizedBox(height: 16.h),

            PrimaryTextFormField(
              readOnly: true,
              controller: _unloadingRegionController,
              labelText: 'Регион выгрузки',
              onTap: () => _showSelectionDialog('Регион выгрузки', (value) {
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
              controller: _unloadingDistrictController,
              labelText: 'Район выгрузки',
              onTap: () => _showSelectionDialog('Район выгрузки', (value) {
                setState(() {
                  _currentFilter = _currentFilter.copyWith(
                    unloadingDistrict: value,
                  );
                  _updateSelectionField(_unloadingDistrictController, value);
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

            SizedBox(height: 24.h),
            _buildDivider(),
            SizedBox(height: 24.h),
            _buildPriceSection(),
            SizedBox(height: 24.h),
            _buildDivider(),
            SizedBox(height: 24.h),
            _buildDistanceSection(),
            SizedBox(height: 24.h),
            _buildDivider(),
            SizedBox(height: 24.h),
            _buildDateSection(),
            SizedBox(height: 24.h),
            _buildDivider(),
            SizedBox(height: 24.h),
            _buildCheckboxSection(),

            SizedBox(height: 32.h),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstants.primaryButtonBackgroundColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'Показать заявки',
                  style: TextStyle(
                    color: ColorsConstants.primaryBrownColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Unbounded',
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: ColorsConstants.primaryBrownColorWithOpacity.withOpacity(0.3),
    );
  }

  Widget _buildSelectField({
    required String title,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorsConstants.primaryBrownColor,
                      fontFamily: 'Unbounded',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value ?? 'Не выбрано',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: value != null
                          ? ColorsConstants.primaryBrownColor
                          : ColorsConstants.primaryBrownColorWithOpacity,
                      fontFamily: 'Unbounded',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Цена, ₽/кг',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.primaryBrownColor,
            fontFamily: 'Unbounded',
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                controller: _minPriceController,
                hintText: 'От',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildNumberField(
                controller: _maxPriceController,
                hintText: 'До',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Расстояние, км',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.primaryBrownColor,
            fontFamily: 'Unbounded',
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                controller: _minDistanceController,
                hintText: 'От',
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildNumberField(
                controller: _maxDistanceController,
                hintText: 'До',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: ColorsConstants.primaryBrownColor,
        fontFamily: 'Unbounded',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: ColorsConstants.primaryBrownColorWithOpacity,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: ColorsConstants.primaryBrownColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: ColorsConstants.primaryBrownColorWithOpacity,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        hintStyle: TextStyle(
          color: ColorsConstants.primaryBrownColorWithOpacity,
          fontFamily: 'Unbounded',
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Дата публикации',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.primaryBrownColor,
            fontFamily: 'Unbounded',
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildDateChip('Любая', DateFilter.any),
            _buildDateChip('За 3 дня', DateFilter.last3Days),
            _buildDateChip('За 5 дней', DateFilter.last5Days),
            _buildDateChip('За 7 дней', DateFilter.last7Days),
          ],
        ),
      ],
    );
  }

  Widget _buildDateChip(String label, DateFilter value) {
    final isSelected = _currentFilter.dateFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? ColorsConstants.primaryBrownColor
              : ColorsConstants.primaryBrownColor,
          fontSize: 14.sp,
          fontFamily: 'Unbounded',
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _currentFilter = _currentFilter.copyWith(dateFilter: value);
          }
        });
      },
      selectedColor: ColorsConstants.primaryButtonBackgroundColor,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      side: BorderSide(color: ColorsConstants.primaryBrownColorWithOpacity),
    );
  }

  Widget _buildCheckboxSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorsConstants.primaryTextFormFieldBackgorundColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: _buildCheckbox(
            title: 'Подходят самосвалы',
            value: _currentFilter.suitableForDumpTrucks,
            onChanged: (value) {
              setState(() {
                _currentFilter = _currentFilter.copyWith(
                  suitableForDumpTrucks: value ?? false,
                );
              });
            },
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: ColorsConstants.primaryTextFormFieldBackgorundColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: _buildCheckbox(
            title: 'Перевозчик работает по хартии',
            value: _currentFilter.charterCarrier,
            onChanged: (value) {
              setState(() {
                _currentFilter = _currentFilter.copyWith(
                  charterCarrier: value ?? false,
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: ColorsConstants.primaryBrownColor,
          checkColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColor,
              fontFamily: 'Unbounded',
            ),
          ),
        ),
      ],
    );
  }

  void _showSelectionDialog(String title, Function(String) onSelected) {
    final items = _demoData[title] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        title: Text(
          'Выбор $title',
          style: TextStyle(
            color: ColorsConstants.primaryBrownColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Unbounded',
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
                        fontFamily: 'Unbounded',
                      ),
                    ),
                    onTap: () {
                      onSelected('');
                      Navigator.of(context).pop();
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
                      fontFamily: 'Unbounded',
                    ),
                  ),
                  onTap: () {
                    onSelected(item);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: ColorsConstants.primaryBrownColor,
                fontFamily: 'Unbounded',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minDistanceController.dispose();
    _maxDistanceController.dispose();
    super.dispose();
  }
}
