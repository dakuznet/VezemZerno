import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_bloc.dart';
import 'package:vezem_zerno/features/profile/presentations/bloc/profile_state.dart';
import 'package:vezem_zerno/features/profile/presentations/screens/widgets/delete_account_confirmation_dialog.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _showDeleteAccountConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is AccountDeleted) {
          AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
          PrimarySnackBar.show(
            context,
            text: 'Аккаунт успешно удалён',
            borderColor: Colors.green,
          );
        } else if (state is AccountDeleteError) {
          PrimarySnackBar.show(
            context,
            text: 'Ошибка удаления аккаунта',
            borderColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            centerTitle: true,
            title: Text(
              'Настройки',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            leading: IconButton(
              onPressed: () => context.router.pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Center(
                    child: PrimaryButton(
                      text: 'Удалить аккаунт',
                      isLoading: state is AccountDeleting,
                      onPressed: () async {
                        _showDeleteAccountConfirmationDialog(context);
                      },
                    ),
                  ),
                ),
                if (state is AccountDeleting) const PrimaryLoadingIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
