import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

@RoutePage()
class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _regionController = TextEditingController();
  final _localityController = TextEditingController();
  final _unloadingRegionController = TextEditingController();
  final _locationOfUnloadingController = TextEditingController();
  final _cropController = TextEditingController();
  final _transportationVolumeController = TextEditingController();
  final _distanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dataStartController = TextEditingController();
  final _dataEndController = TextEditingController();
  final _loadingWeightCapacityController = TextEditingController();
  final _shippingPriceController = TextEditingController();
  final _downtimePaymentController = TextEditingController();
  final _allowableShortageController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  
  String _selectedCategory = 'Не указано';
  DateTime? _selectedDate;
  bool _isUrgent = false;
  bool _suitableForDumpTrucks = false;
  bool _carrierWorksByCharter = false;
  String _paymentMethod = 'cash'; // 'cash' or 'cashless'
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        title:  Text('Создание заявки', style: TextStyle(
          fontSize: 16.sp,
          color: ColorsConstants.primaryBrownColor,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
      ),
      body: Container(
        color: ColorsConstants.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [ 
                _buildLoadingFields(),
                SizedBox(height: 20.h),
                _buildUnloadingFields(),
                SizedBox(height: 20.h),
                _buildCargoFields(),
                SizedBox(height: 20.h),
                Text('Условия погрузки', style: StyleForTitle(),),
                SizedBox(height: 20.h),
                _buildDateStartField(),
                SizedBox(height: 20.h),
                _buildDateEndField(),
                SizedBox(height: 20.h),
                _buildChoseLoadingMethod(),
                SizedBox(height: 20.h),
                _buildTextFormField(
                  labelStyle: StyleForFormField(),
                 controller: _loadingWeightCapacityController,
                  labelText: 'Грузоподъемность весов на погрузке, тонн',
                  validator: (value) => _validateNotEmpty(value, 'грузоподъемность весов'),
                ),
               SizedBox(height: 20.h),
               Text('Детали перевозки', style: StyleForTitle(),),
                SizedBox(height: 20.h),
               _buildCheckboxFields(),
                SizedBox(height: 20.h),
                _buildAdditionalFields(),
                SizedBox(height: 20.h),
                _buildPaymentMethodField(),
                SizedBox(height: 20.h),
                
                _buildDescriptionField(),
                SizedBox(height: 20.h),
                
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Основное",
      style:  StyleForTitle()),
      SizedBox(height: 20.h),
      Text("Место погрузки",style: StyleForSubtitle(), ),
          SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _regionController,
        labelText: 'Регион погрузки',
        validator: (value) => _validateNotEmpty(value, 'регион погрузки'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _localityController,
        labelText: 'Населенный пункт погрузки',
        validator: (value) => _validateNotEmpty(value, 'населенный пункт погрузки'),
      ),
    ],
  );



  Widget _buildUnloadingFields() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Место выгрузки",style: StyleForSubtitle(), ),
          SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _unloadingRegionController,
        labelText: 'Регион выгрузки',
        validator: (value) => _validateNotEmpty(value, 'регион выгрузки'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _locationOfUnloadingController,
        labelText: 'Населенный пункт выгрузки',
        validator: (value) => _validateNotEmpty(value, 'населенный пункт выгрузки'),
      ),
    ],
  );

  Widget _buildCargoFields() => Column(
    children: [
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _cropController,
        labelText: 'Введите культуру',
        validator: (value) => _validateNotEmpty(value, 'культуру'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _transportationVolumeController,
        labelText: 'Введите объём перевозки, тонн',
        validator: (value) => _validateNotEmpty(value, 'объём перевозки'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _distanceController,
        labelText: 'Введите расстояние, км',
        validator: (value) => _validateNotEmpty(value, 'расстояние'),
      ),
    ],
  );
  Widget _buildAdditionalFields() => Column(
    children: [
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _shippingPriceController,
        labelText: 'Цена перевозки, руб',
        validator: (value) => _validateNotEmpty(value, 'цену перевозки'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _downtimePaymentController,
        labelText: 'Как оплачиваете простой',
        validator: (value) => _validateNotEmpty(value, 'условия оплаты простоя'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _allowableShortageController,
        labelText: 'Допустимая недостача, кг',
        validator: (value) => _validateNotEmpty(value, 'допустимую недостачу'),
      ),
      SizedBox(height: 20.h),
      _buildTextFormField(
        labelStyle: StyleForFormField(),
        controller: _paymentTermsController,
        labelText: 'Сроки оплаты',
        validator: (value) => _validateNotEmpty(value, 'сроки оплаты'),
      ),
    ],
  );

Widget _buildCheckboxFields() => Column(
  children: [
    Container(
      decoration: BoxDecoration(
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        borderRadius: BorderRadius.circular(15.0.r),
        border: Border.all(
          color: Colors.black, // Черная обводка
          width: 1.0,
        ),
      ),
      child: CheckboxListTile(
        title:  Text('Подходят самосвалы',style: StyleForChooseBlock()),
        value: _suitableForDumpTrucks,
        activeColor: ColorsConstants.primaryButtonBackgroundColor,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
        onChanged: (bool? value) {
          setState(() {
            _suitableForDumpTrucks = value ?? false;
          });
        },
      ),
    ),
    SizedBox(height: 10.h),
    Container(
      decoration: BoxDecoration(
        
        color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        borderRadius: BorderRadius.circular(15.0.r),
        border: Border.all(
          color: Colors.black, 
          width: 1.0,
        ),
      ),
      child: CheckboxListTile(
        title:  Text('Перевозчик работает по хартии',style: StyleForChooseBlock()),
        value: _carrierWorksByCharter,
        activeColor: ColorsConstants.primaryButtonBackgroundColor,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.w),
        onChanged: (bool? value) {
          setState(() {
            _carrierWorksByCharter = value ?? false;
          });
        },
      ),
    ),
  ],
);

Widget _buildPaymentMethodField() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Text(
      'Способ оплаты',
      style: StyleForSubtitle(),
    ),
    SizedBox(height: 10.h),
    Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: ColorsConstants.primaryTextFormFieldBackgorundColor,
              borderRadius: BorderRadius.circular(12.0.r),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: RadioListTile<String>(
              activeColor: ColorsConstants.primaryButtonBackgroundColor,
              title:  Text('Наличные',style: StyleForChooseBlock(),),
              value: 'cash',
              groupValue: _paymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _paymentMethod = value ?? 'cash';
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8.w),
            decoration: BoxDecoration(
              color: ColorsConstants.primaryTextFormFieldBackgorundColor,
              borderRadius: BorderRadius.circular(15.0.r),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: RadioListTile<String>(
              activeColor: ColorsConstants.primaryButtonBackgroundColor,
              title:  Text('Безналичные',style: StyleForChooseBlock()),
              value: 'cashless',
              groupValue: _paymentMethod,
              onChanged: (String? value) {
                setState(() {
                  _paymentMethod = value ?? 'cashless';
                });
              },
            ),
          ),
        ),
      ],
    ),
  ],
);


  Widget _buildDescriptionField() => _buildTextFormField(
    labelStyle: StyleForFormField(),
    controller: _descriptionController,
    labelText: 'Описание',
    maxLines: 5,
    validator: (value) => _validateNotEmpty(value, 'описание'),
  );

  Widget _buildDateStartField() => Row(
  children: [
    Expanded(
      child: InkWell(
        onTap: () => _selectStartDate(context),
        child: IgnorePointer(
          child: TextFormField(
            controller: _dataStartController,
            decoration: InputDecoration(
              fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
              filled: true,
              labelText: 'Дата начала погрузки',
              labelStyle: StyleForFormField(),
              border: BorderStyle(),
            ),
            style:  StyleForChooseBlock(),
            validator: (value) => _validateNotEmpty(value, 'дата начала'),
          ),
        ),
      ),
    ),
  ],
);

Widget _buildDateEndField() => Row(
  children: [
    Expanded(
      child: InkWell(
        onTap: () => _selectEndDate(context),
        child: IgnorePointer(
          child: TextFormField(
            controller: _dataEndController,
            decoration: InputDecoration(
              fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
              filled: true,
              labelText: 'Дата закрытия получения заявок',
             labelStyle: StyleForFormField(),
              border: BorderStyle(),
            ),
            style:  StyleForChooseBlock(),
            validator: (value) => _validateNotEmpty(value, 'дата закрытия'),
          ),
        ),
      ),
    ),
  ],
);


  Widget _buildChoseLoadingMethod() => DropdownButtonFormField<String>(
    style: StyleForChooseBlock(),
    value: _selectedCategory,
    items: const [
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
    decoration:  InputDecoration(
      fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
      filled: true,
      labelStyle: StyleForFormField(),
      labelText: 'Выберите способ погрузки',
      border: BorderStyle(),
    ),
  );

  Widget _buildSubmitButton() => ElevatedButton(
    onPressed: _submitForm,
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorsConstants.primaryButtonBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 15.h),
    ),
    child: Text(
      'Создать заявку',
      style: TextStyle(color: ColorsConstants.primaryBrownColor, fontSize: 16.sp, fontFamily: 'Unbounded',fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    required String? Function(String?) validator,
    TextStyle? style, 
    TextStyle? labelStyle, 
    TextStyle? hintStyle,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        filled: true,
        labelText: labelText,
        labelStyle: labelStyle, 
        hintStyle: hintStyle, 
        border: BorderStyle(),
        alignLabelWithHint: true,
      ),
      style: style, 
      maxLines: maxLines,
      validator: validator,
    );
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите $fieldName';
    }
    return null;
  }

  Future<void> _selectStartDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    setState(() {
      _selectedStartDate = picked;
      _dataStartController.text = "${picked.day}.${picked.month}.${picked.year}";
    });
  }
}

Future<void> _selectEndDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
  if (picked != null) {
    setState(() {
      _selectedEndDate = picked;
      _dataEndController.text = "${picked.day}.${picked.month}.${picked.year}";
    });
  }
}

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'loadingRegion': _regionController.text,
        'loadingLocality': _localityController.text,
        'unloadingRegion': _unloadingRegionController.text,
        'unloadingLocality': _locationOfUnloadingController.text,
        'crop': _cropController.text,
        'volume': _transportationVolumeController.text,
        'distance': _distanceController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'dateStart': _dataStartController.text,
        'dateEnd': _dataEndController.text,
        'isUrgent': _isUrgent,
        'loadingWeightCapacity': _loadingWeightCapacityController.text,
        'shippingPrice': _shippingPriceController.text,
        'downtimePayment': _downtimePaymentController.text,
        'allowableShortage': _allowableShortageController.text,
        'paymentTerms': _paymentTermsController.text,
        'suitableForDumpTrucks': _suitableForDumpTrucks,
        'carrierWorksByCharter': _carrierWorksByCharter,
        'paymentMethod': _paymentMethod,
      };

      print(requestData);



      // Показать уведомление об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заявка успешно создана!'),
          backgroundColor: Colors.green,
        ),
      );

      // Очистка формы после успешного создания
      _formKey.currentState!.reset();
      setState(() {
        _selectedEndDate = null;
        _selectedStartDate = null;
        _isUrgent = false;
        _suitableForDumpTrucks = false;
        _carrierWorksByCharter = false;
        _paymentMethod = 'cash';
        _selectedCategory = 'Не указано';
        
      });
    }
  }

  @override
  void dispose() {
    _regionController.dispose();
    _localityController.dispose();
    _unloadingRegionController.dispose();
    _locationOfUnloadingController.dispose();
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


    TextStyle StyleForFormField() {
    return TextStyle( fontSize: 12.sp,
        color: ColorsConstants.primaryBrownColorWithOpacity,
        fontFamily: 'Unbounded',
        fontWeight: FontWeight.w400, );
  }

    TextStyle StyleForSubtitle() {
      return TextStyle(
        fontSize: 12.sp,
          color: ColorsConstants.primaryBrownColor,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w400,);
    }

    TextStyle StyleForTitle() {
        return TextStyle(
        fontSize: 16.sp,
          color: ColorsConstants.primaryBrownColor,
          fontFamily: 'Unbounded',
          fontWeight: FontWeight.w500);
          }

    TextStyle StyleForChooseBlock() {
      return TextStyle(fontSize: 12.sp,
        color: ColorsConstants.primaryBrownColor,
        fontFamily: 'Unbounded',
        fontWeight: FontWeight.w400,);
    }

    OutlineInputBorder BorderStyle() {
  return OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0.r),
              borderSide: BorderSide(color: Colors.black, width: 1.0),
            );
}

}