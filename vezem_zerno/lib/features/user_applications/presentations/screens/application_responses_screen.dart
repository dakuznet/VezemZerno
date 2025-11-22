import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/features/user_applications/presentations/screens/widgets/user_response_card.dart';

@RoutePage()
class ApplicationResponsesScreen extends StatefulWidget {
  final String applicationId;

  const ApplicationResponsesScreen({super.key, required this.applicationId});

  @override
  State<ApplicationResponsesScreen> createState() =>
      _ApplicationResponsesScreenState();
}

class _ApplicationResponsesScreenState
    extends State<ApplicationResponsesScreen> {
  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  void _loadResponses() {
    context.read<UserApplicationsBloc>().add(
      LoadApplicationResponsesEvent(applicationId: widget.applicationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Отклики',
          style: TextStyle(
            fontSize: 20.sp,
            color: ColorsConstants.primaryBrownColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
        foregroundColor: ColorsConstants.primaryBrownColor,
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: BlocConsumer<UserApplicationsBloc, UserApplicationsState>(
        listener: (context, state) {
          if (state is ResponseAcceptingSuccess) {
            PrimarySnackBar.show(
              context,
              text: 'Отклик успешно принят',
              borderColor: Colors.green,
            );
            context.router.pop();
          } else if (state is ResponseAcceptingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Произошла ошибка при принятии отклика'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              if (state is UserApplicationResponsesLoading)
                SliverFillRemaining(child: PrimaryLoadingIndicator()),
              if (state is UserApplicationResponsesLoadingSuccess) ...[
                if (state.users.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                color: ColorsConstants
                                    .primaryTextFormFieldBackgorundColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.list_alt_outlined,
                                size: 40.sp,
                                color: ColorsConstants
                                    .primaryBrownColorWithOpacity,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Никто ещё не откликнулся на Вашу заявку',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: ColorsConstants
                                    .primaryBrownColorWithOpacity,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (state.users.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => UserResponseCard(
                        user: state.users[index],
                        applicationId: widget.applicationId,
                      ),
                      childCount: state.users.length,
                    ),
                  ),
              ],
              if (state is UserApplicationResponsesLoadingFailure)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: ColorsConstants
                                  .primaryTextFormFieldBackgorundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 40.sp,
                              color:
                                  ColorsConstants.primaryBrownColorWithOpacity,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Произошла ошибка при загрузке откликов',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color:
                                  ColorsConstants.primaryBrownColorWithOpacity,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          PrimaryButton(
                            text: 'Повторить',
                            onPressed: _loadResponses,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
