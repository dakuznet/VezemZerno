import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/services/appwrite_service.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/core/widgets/primary_text_form_field.dart';
import 'package:vezem_zerno/features/user_application_list/data/models/application_model.dart';
import 'package:vezem_zerno/features/user_application_list/domain/entities/application_entity.dart';

@RoutePage()
class CreateApplicationScreen extends StatefulWidget {
  const CreateApplicationScreen({super.key});

  @override
  State<CreateApplicationScreen> createState() =>
      _CreateApplicationScreenState();
}

class _CreateApplicationScreenState extends State<CreateApplicationScreen> {
  final ApplicationStatus _applicationStatus = ApplicationStatus.active;

  final _formKey = GlobalKey<FormState>();

  final _loadingRegionController = TextEditingController();
  final _loadingLocalityController = TextEditingController();

  final _unloadingRegionController = TextEditingController();
  final _unloadingLocalityController = TextEditingController();

  final _cropController = TextEditingController();
  final _transportationVolumeController = TextEditingController();
  final _distanceController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _loadingDateController = TextEditingController();

  final _loadingWeightCapacityController = TextEditingController();
  final _shippingPriceController = TextEditingController();
  final _downtimePaymentController = TextEditingController();
  final _allowableShortageController = TextEditingController();
  final _paymentTermsController = TextEditingController();

  String _selectedCategory = 'Не указано';
  bool _suitableForDumpTrucks = false;
  bool _carrierWorksByCharter = false;
  String? _paymentMethod;

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      centerTitle: true,
      title: Text(
        'Создание заявки',
        style: TextStyle(
          fontFamily: 'Unbounded',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: ColorsConstants.primaryBrownColor,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: ColorsConstants.primaryBrownColor,
        onPressed: () => AutoRouter.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -ОСНОВНОЕ
                Text(
                  "Основное",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                // --МЕСТО ПОГРУЗКИ
                Text(
                  "Место погрузки",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Регион погрузки',
                  controller: _loadingRegionController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'регион погрузки'),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Населённый пункт погрузки',
                  controller: _loadingLocalityController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'населённый пункт погрузки'),
                ),
                SizedBox(height: 16.h),
                // --МЕСТО ВЫГРУЗКИ
                Text(
                  "Место выгрузки",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Регион выгрузки',
                  controller: _unloadingRegionController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'регион выгрузки'),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Населённый пункт выгрузки',
                  controller: _unloadingLocalityController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'населённый пункт выгрузки'),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Divider(
                    color: ColorsConstants.primaryBrownColor,
                    thickness: 2.sp,
                  ),
                ),
                // --ДАННЫЕ О ГРУЗЕ
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Введите расстояние, км',
                  controller: _distanceController,
                  validator: (value) => _validateNotEmpty(value, 'расстояние'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Введите культуру',
                  controller: _cropController,
                  validator: (value) => _validateNotEmpty(value, 'культуру'),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Введите объём перевозки, тонн',
                  controller: _transportationVolumeController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'объём перевозки'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Divider(
                    color: ColorsConstants.primaryBrownColor,
                    thickness: 2.sp,
                  ),
                ),
                SizedBox(height: 32.h),

                // -УСЛОВИЯ ПОГРУЗКИ
                Text(
                  'Условия погрузки',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: () => _selectLoadingDate(context),
                  child: IgnorePointer(
                    child: PrimaryTextFormField(
                      readOnly: true,
                      labelText: 'Дата начала погрузки',
                      controller: _loadingDateController,
                      validator: (value) =>
                          _validateNotEmpty(value, 'дату начала погрузки'),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  borderRadius: BorderRadius.circular(12.r),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                  dropdownColor:
                      ColorsConstants.primaryTextFormFieldBackgorundColor,
                  initialValue: _selectedCategory,
                  items:
                      const [
                        'Не указано',
                        'Вертикальный',
                        'Зерномет',
                        'Элеватор',
                        'Кун',
                        'Манитару',
                        'С поля',
                        'Кара',
                        'Амкадор',
                        'Зерномет и кун',
                        'Зерномет и маниту',
                      ].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        ColorsConstants.primaryTextFormFieldBackgorundColor,
                    labelText: 'Выберите способ погрузки',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      fontFamily: 'Unbounded',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorsConstants.primaryBrownColorWithOpacity,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16).r,
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16).r,
                      borderSide: BorderSide(color: Colors.red, width: 2.w),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16).r,
                      borderSide: BorderSide(color: Colors.red, width: 2.w),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Грузоподъемность весов на погрузке, тонн',
                  validator: (value) =>
                      _validateNotEmpty(value, 'грузоподъемность весов'),
                  controller: _loadingWeightCapacityController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 32.h),
                Text(
                  'Детали перевозки',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      'Подходят самосвалы',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsConstants.primaryBrownColor,
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: _suitableForDumpTrucks,
                    activeColor: ColorsConstants.primaryBrownColor,
                    checkColor: Colors.white,
                    onChanged: (bool? value) {
                      setState(() => _suitableForDumpTrucks = value ?? false);
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  decoration: BoxDecoration(
                    color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      'Перевозчик работает по хартии',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsConstants.primaryBrownColor,
                        fontFamily: 'Unbounded',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    value: _carrierWorksByCharter,
                    activeColor: ColorsConstants.primaryBrownColor,
                    checkColor: Colors.white,
                    onChanged: (bool? value) {
                      setState(() => _carrierWorksByCharter = value ?? false);
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Цена перевозки ₽/кг',
                  controller: _shippingPriceController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'цену перевозки'),
                  keyboardType: TextInputType.number,
                ),

                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Как оплачиваете простой',
                  controller: _downtimePaymentController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'условия оплаты простоя'),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Допустимая недостача, кг',
                  controller: _allowableShortageController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'допустимую недостачу'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Сроки оплаты',
                  controller: _paymentTermsController,
                  validator: (value) =>
                      _validateNotEmpty(value, 'сроки оплаты'),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 32.h),
                Text(
                  'Способ оплаты',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorsConstants.primaryBrownColor,
                    fontFamily: 'Unbounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                // Заменяем RadioGroup на Column с RadioListTile
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                      child: RadioListTile<String>(
                        activeColor: ColorsConstants.primaryBrownColor,
                        title: Text(
                          'Наличные',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorsConstants.primaryBrownColor,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: 'cash',
                        groupValue: _paymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            ColorsConstants.primaryTextFormFieldBackgorundColor,
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                      child: RadioListTile<String>(
                        activeColor: ColorsConstants.primaryBrownColor,
                        title: Text(
                          'Безналичные',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorsConstants.primaryBrownColor,
                            fontFamily: 'Unbounded',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: 'cashless',
                        groupValue: _paymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _paymentMethod = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                PrimaryTextFormField(
                  readOnly: false,
                  labelText: 'Комментарий к заявке',
                  controller: _descriptionController,
                  maxLines: 5,
                ),
                SizedBox(height: 32.h),

                PrimaryButton(
                  text: 'Создать заявку',
                  onPressed: () => _submitForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Введите $fieldName';
    }
    return null;
  }

  Future<void> _selectLoadingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _loadingDateController.text =
            "${picked.day}.${picked.month}.${picked.year}";
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        AppwriteService appwriteService = AppwriteService();

        final currentUser = await appwriteService.getCurrentUser();

        final application = ApplicationModel(
          customerId: currentUser.id,
          organization: currentUser.organization!,
          loadingPlace:
              '${_loadingRegionController.text}\n${_loadingLocalityController.text}',
          unloadingPlace:
              '${_unloadingRegionController.text}\n${_unloadingLocalityController.text}',
          crop: _cropController.text,
          tonnage: _transportationVolumeController.text,
          distance: _distanceController.text,
          comment: _descriptionController.text,
          loadingMethod: _selectedCategory,
          loadingDate: _loadingDateController.text,
          scalesCapacity: _loadingWeightCapacityController.text,
          price: _shippingPriceController.text,
          downtime: _downtimePaymentController.text,
          shortage: _allowableShortageController.text,
          paymentTerms: _paymentTermsController.text,
          dumpTrucks: _suitableForDumpTrucks,
          charter: _carrierWorksByCharter,
          paymentMethod: _paymentMethod ?? 'cash',
          status: _applicationStatus.value,
        );

        await appwriteService.createApplication(application);

        // Показать уведомление об успехе
        PrimarySnackBar.show(
          context,
          text: 'Заявка успешно создана',
          borderColor: Colors.green,
        );

        // Очистка формы после успешного создания
        _formKey.currentState!.reset();
        setState(() {
          _suitableForDumpTrucks = false;
          _carrierWorksByCharter = false;
          _selectedCategory = 'Не указано';
        });

        if (mounted) {
          AutoRouter.of(context).pop();
        }
      } catch (e) {
        // Показать ошибку
        PrimarySnackBar.show(
          context,
          text: 'Ошибка при создании заявки: $e',
          borderColor: Colors.red,
        );
      }
    }
  }

  @override
  void dispose() {
    _loadingRegionController.dispose();
    _loadingLocalityController.dispose();

    _unloadingRegionController.dispose();
    _unloadingLocalityController.dispose();

    _cropController.dispose();
    _transportationVolumeController.dispose();
    _distanceController.dispose();

    _descriptionController.dispose();
    _loadingWeightCapacityController.dispose();
    _shippingPriceController.dispose();
    _downtimePaymentController.dispose();
    _allowableShortageController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }
}
