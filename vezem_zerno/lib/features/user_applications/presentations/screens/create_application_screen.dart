import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/basic_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/comment_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/loading_conditions_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/payment_method_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/transport_details_section.dart';

@RoutePage()
class CreateApplicationScreen extends StatefulWidget {
  const CreateApplicationScreen({super.key});

  @override
  State<CreateApplicationScreen> createState() =>
      _CreateApplicationScreenState();
}

class _CreateApplicationScreenState extends State<CreateApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController loadingRegionController;
  late final TextEditingController loadingLocalityController;
  late final TextEditingController unloadingRegionController;
  late final TextEditingController unloadingLocalityController;
  late final TextEditingController cropController;
  late final TextEditingController transportationVolumeController;
  late final TextEditingController distanceController;
  late final TextEditingController descriptionController;
  late final TextEditingController loadingDateController;
  late final TextEditingController loadingWeightCapacityController;
  late final TextEditingController shippingPriceController;
  late final TextEditingController downtimePaymentController;
  late final TextEditingController allowableShortageController;
  late final TextEditingController paymentTermsController;
  String selectedCategory = 'Не указано';
  bool suitableForDumpTrucks = false;
  bool carrierWorksByCharter = false;
  String paymentMethod = 'Наличные';

  @override
  void initState() {
    loadingRegionController = TextEditingController();
    loadingLocalityController = TextEditingController();
    unloadingRegionController = TextEditingController();
    unloadingLocalityController = TextEditingController();
    cropController = TextEditingController();
    transportationVolumeController = TextEditingController();
    distanceController = TextEditingController();
    descriptionController = TextEditingController();
    loadingDateController = TextEditingController();
    loadingWeightCapacityController = TextEditingController();
    shippingPriceController = TextEditingController();
    downtimePaymentController = TextEditingController();
    allowableShortageController = TextEditingController();
    paymentTermsController = TextEditingController();
    super.initState();
  }

  void _submitForm() {
    final authState = context.read<AuthBloc>().state;
    if (_formKey.currentState!.validate() && authState is LoginSuccess) {
      context.read<UserApplicationsBloc>().add(
        CreateUserApplicaitonEvent(
          userId: authState.user.id,
          loadingRegion: loadingRegionController.text,
          loadingLocality: loadingLocalityController.text,
          unloadingRegion: unloadingRegionController.text,
          unloadingLocality: unloadingLocalityController.text,
          crop: cropController.text,
          tonnage: transportationVolumeController.text,
          distance: distanceController.text,
          comment: descriptionController.text,
          loadingMethod: selectedCategory,
          loadingDate: loadingDateController.text,
          scalesCapacity: loadingWeightCapacityController.text,
          price: shippingPriceController.text,
          downtime: downtimePaymentController.text,
          shortage: allowableShortageController.text,
          paymentTerms: paymentTermsController.text,
          dumpTrucks: suitableForDumpTrucks,
          charter: carrierWorksByCharter,
          paymentMethod: paymentTermsController.text,
          status: 'active',
        ),
      );
    }
  }

  void _onCategoryChanged(String newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });
  }

  void _onSuitableForDumpTrucksChanged(bool newValue) {
    setState(() {
      suitableForDumpTrucks = newValue;
    });
  }

  void _onCarrierWorksByCharterChanged(bool newValue) {
    setState(() {
      carrierWorksByCharter = newValue;
    });
  }

  void _onPaymentMethodChanged(String newValue) {
    setState(() {
      paymentMethod = newValue;
    });
  }

  @override
  void dispose() {
    loadingRegionController.dispose();
    loadingLocalityController.dispose();
    unloadingRegionController.dispose();
    unloadingLocalityController.dispose();
    cropController.dispose();
    transportationVolumeController.dispose();
    distanceController.dispose();
    descriptionController.dispose();
    loadingWeightCapacityController.dispose();
    shippingPriceController.dispose();
    downtimePaymentController.dispose();
    allowableShortageController.dispose();
    paymentTermsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserApplicationsBloc, UserApplicationsState>(
      listener: (context, state) {
        if (state is UserApplicationCreatingSuccess) {
          PrimarySnackBar.show(
            context,
            text: 'Заявка создана и опубликована!',
            borderColor: Colors.green,
          );
          context.read<ApplicationsBloc>().add(
            LoadApplicationsEvent(applicationStatus: 'active'),
          );
          AutoRouter.of(context).pop();
        } else if (state is UserApplicationCreatingFailure) {
          PrimarySnackBar.show(
            context,
            text: 'Произошла ошибка при создании заявки',
            borderColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            centerTitle: true,
            title: Text(
              'Создание заявки',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: ColorsConstants.primaryBrownColor,
              onPressed: () => context.router.pop(),
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BasicSection(
                      loadingLocalityController: loadingLocalityController,
                      loadingRegionController: loadingRegionController,
                      unloadingLocalityController: unloadingLocalityController,
                      cropController: cropController,
                      distanceController: distanceController,
                      unloadingRegionController: unloadingRegionController,
                      transportationVolumeController:
                          transportationVolumeController,
                    ),
                    SizedBox(height: 32.h),
                    LoadingConditionsSection(
                      selectedCategory: selectedCategory,
                      loadingDateController: loadingDateController,
                      loadingWeightCapacityController:
                          loadingWeightCapacityController,
                      onCategoryChanged: _onCategoryChanged,
                    ),
                    SizedBox(height: 32.h),
                    TransportDetailsSection(
                      suitableForDumpTrucks: suitableForDumpTrucks,
                      onSuitableForDumpTrucksChanged:
                          _onSuitableForDumpTrucksChanged,
                      carrierWorksByCharter: carrierWorksByCharter,
                      onCarrierWorksByCharterChanged:
                          _onCarrierWorksByCharterChanged,
                      shippingPriceController: shippingPriceController,
                      downtimePaymentController: downtimePaymentController,
                      allowableShortageController: allowableShortageController,
                      paymentTermsController: paymentTermsController,
                    ),
                    SizedBox(height: 32.h),
                    PaymentMethodSection(
                      paymentMethod: paymentMethod,
                      onPaymentMethodChanged: _onPaymentMethodChanged,
                    ),
                    SizedBox(height: 32.h),
                    CommentSection(
                      descriptionController: descriptionController,
                    ),
                    SizedBox(height: 32.h),
                    PrimaryButton(
                      text: 'Создать и опубликовать заявку',
                      onPressed: _submitForm,
                      isLoading: state is UserApplicationCreating,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
