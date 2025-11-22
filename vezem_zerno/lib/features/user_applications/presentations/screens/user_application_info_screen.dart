import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/action_buttons_section.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/application_info_section.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class UserApplicationInfoScreen extends StatefulWidget {
  final ApplicationEntity application;

  const UserApplicationInfoScreen({super.key, required this.application});

  @override
  State<UserApplicationInfoScreen> createState() =>
      _UserApplicationInfoScreenState();
}

class _UserApplicationInfoScreenState extends State<UserApplicationInfoScreen> {
  @override
  void initState() {
    super.initState();
    _loadCarrierInfo();
  }

  void _loadCarrierInfo() {
    final application = widget.application;
    if (application.status == 'processing' ||
        application.status == 'completed') {
      if (application.carrier != null) {
        context.read<UserApplicationsBloc>().add(
          LoadCarrierInfoEvent(carrierId: application.carrier!),
        );
      }
    }
  }

  bool _isCustomer(AuthState authState) {
    return authState is SessionRestored
        ? authState.user.role == 'Заказчик'
        : authState is LoginSuccess
        ? authState.user.role == 'Заказчик'
        : false;
  }

  void _blocListener(BuildContext context, UserApplicationsState state) {
    if (state is ApplicationMarkingDeliveredSuccess) {
      PrimarySnackBar.show(
        context,
        text: 'Заявка выполнена',
        borderColor: Colors.green,
      );
    } else if (state is ApplicationMarkingComlepetedSuccess) {
      PrimarySnackBar.show(
        context,
        text: 'Заявка завершена',
        borderColor: Colors.green,
      );
    } else if (state is ApplicationMarkingComlepetedFailure ||
        state is ApplicationMarkingDeliveredFailure) {
      String error;
      if (state is ApplicationMarkingComlepetedFailure) {
        error = (state).error;
      } else {
        error = (state as ApplicationMarkingDeliveredFailure).error;
      }
      PrimarySnackBar.show(context, text: error, borderColor: Colors.red);
    }
  }

  void _navigateToResponses() {
    if (widget.application.id != null) {
      context.router.push(
        ApplicationResponsesRoute(applicationId: widget.application.id!),
      );
    }
  }

  void _markApplicationDelivered() {
    final authState = context.read<AuthBloc>().state;
    if (widget.application.id != null && authState is LoginSuccess) {
      context.read<UserApplicationsBloc>().add(
        MarkApplicationDeliveredEvent(applicationId: widget.application.id!, userId: authState.user.id),
      );
    }
  }

  void _markApplicationCompleted() {
    final authState = context.read<AuthBloc>().state;
    if (widget.application.id != null && authState is LoginSuccess) {
      context.read<UserApplicationsBloc>().add(
        MarkApplicationCompletedEvent(applicationId: widget.application.id!, userId: authState.user.id),
      );
      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isCustomer = _isCustomer(authState);
        return Scaffold(
          backgroundColor: ColorsConstants.backgroundColor,
          appBar: AppBar(
            actions: [
              if (isCustomer && widget.application.status == 'active')
                TextButton(
                  onPressed: () => _navigateToResponses(),
                  child: Text(
                    'К откликам',
                    style: TextStyle(
                      color: ColorsConstants.primaryBrownColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
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
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            foregroundColor: ColorsConstants.primaryBrownColor,
          ),
          body: BlocConsumer<UserApplicationsBloc, UserApplicationsState>(
            listener: _blocListener,
            builder: (context, state) => SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApplicationInfoSection(
                    application: widget.application,
                    isCustomer: isCustomer,
                    blocState: state,
                  ),
                  SizedBox(height: 16.h),
                  ActionButtonsSection(
                    application: widget.application,
                    isCustomer: isCustomer,
                    onMarkDelivered: () => _markApplicationDelivered(),
                    onMarkCompleted: () => _markApplicationCompleted(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
