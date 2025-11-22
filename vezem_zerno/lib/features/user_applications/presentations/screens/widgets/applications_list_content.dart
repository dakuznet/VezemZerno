import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/features/user_applications/presentations/bloc/user_applications_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

class ApplicationsListContent extends StatelessWidget {
  final List<ApplicationEntity> applications;
  final VoidCallback onRefresh;
  final String status;

  const ApplicationsListContent({
    super.key,
    required this.applications,
    required this.onRefresh,
    required this.status,
  });

  String _getEmptyMessageForStatus(String status) {
    switch (status) {
      case 'active':
        return 'Список Ваших активных заявок пуст';
      case 'processing':
        return 'Список Ваших заявок, находящихся в работе, пуст';
      case 'completed':
        return 'Список Ваших завершенных заявок пуст';
      default:
        return 'Список Ваших заявок пуст';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserApplicationsBloc, UserApplicationsState>(
      builder: (context, state) {
        final isLoading =
            state is UserApplicationsLoading && state.status == status;

        final hasError =
            state is UserApplicationsLoadFailure && state.status == status;
        return RefreshIndicator(
          color: ColorsConstants.primaryBrownColor,
          backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
          onRefresh: () async => onRefresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isLoading)
                SliverToBoxAdapter(
                  child: const PrimaryLoadingIndicator(),
                )
              else if (hasError)
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
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Не удалось загрузить заявки',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: onRefresh,
                            child: Text(
                              'Повторить',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: ColorsConstants.primaryBrownColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (applications.isEmpty)
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
                              color:
                                  ColorsConstants.primaryBrownColorWithOpacity,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _getEmptyMessageForStatus(status),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color:
                                  ColorsConstants.primaryBrownColorWithOpacity,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemBuilder: (context, index) => ApplicationCard(
                    application: applications[index],
                    onTap: () => context.router.push(
                      UserApplicationInfoRoute(
                        application: applications[index],
                      ),
                    ),
                  ),
                  itemCount: applications.length,
                ),
            ],
          ),
        );
      },
    );
  }
}
