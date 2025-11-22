import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_content.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_form_data.dart';

@RoutePage()
class CreateApplicationScreen extends StatefulWidget {
  const CreateApplicationScreen({super.key});

  @override
  State<CreateApplicationScreen> createState() =>
      _CreateApplicationScreenState();
}

class _CreateApplicationScreenState extends State<CreateApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = ApplicationFormData();

  void _submitForm() {
    final authState = context.read<AuthBloc>().state;
    if (_formKey.currentState!.validate() && authState is LoginSuccess) {
      context.read<UserApplicationsBloc>().add(
        CreateUserApplicaitonEvent(
          userId: authState.user.id,
          loadingRegion: _formData.loadingRegion,
          loadingLocality: _formData.loadingLocality,
          unloadingRegion: _formData.unloadingRegion,
          unloadingLocality: _formData.unloadingLocality,
          crop: _formData.crop,
          tonnage: _formData.transportationVolume,
          distance: _formData.distance,
          comment: _formData.description,
          loadingMethod: _formData.selectedCategory,
          loadingDate: _formData.loadingDate,
          scalesCapacity: _formData.loadingWeightCapacity,
          price: _formData.shippingPrice,
          downtime: _formData.downtimePayment,
          shortage: _formData.allowableShortage,
          paymentTerms: _formData.paymentTerms,
          dumpTrucks: _formData.suitableForDumpTrucks,
          charter: _formData.carrierWorksByCharter,
          paymentMethod: _formData.paymentMethod ?? 'Наличные',
          status: 'active',
        ),
      );
    }
  }

  @override
  void dispose() {
    _formData.dispose();
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
            child: Form(
              key: _formKey,
              child: ApplicationFormContent(
                formData: _formData,
                isLoading: state is UserApplicationCreating,
                onSubmit: _submitForm,
              ),
            ),
          ),
        );
      },
    );
  }
}
