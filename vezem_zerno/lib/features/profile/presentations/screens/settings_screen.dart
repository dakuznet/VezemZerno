import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/core/widgets/primary_snack_bar.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
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
          PrimarySnackBar.show(
            context: context,
            text: 'Аккаунт успешно удалён',
            borderColor: Colors.green,
          );
          context.read<AuthBloc>().add(AuthLogoutEvent());
          AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
        } else if (state is AccountDeleteError) {
          PrimarySnackBar.show(
            context: context,
            text: 'Ошибка удаления аккаунта\n${state.message}',
            borderColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        final isDeleting = state is AccountDeleting;
        return Scaffold(
          appBar: _buildAppBar(context, state),
          backgroundColor: ColorsConstants.backgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Center(
                    child: PrimaryButton(
                      text: 'Удалить аккаунт',
                      onPressed: isDeleting
                          ? null
                          : () async {
                              _showDeleteAccountConfirmationDialog(context);
                            },
                    ),
                  ),
                ),
                if (isDeleting)
                  Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4.w,
                      backgroundColor:
                          ColorsConstants.primaryTextFormFieldBackgorundColor,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context, ProfileState state) {
  return AppBar(
    backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
    centerTitle: true,
    title: Text(
      'Настройки',
      style: TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: ColorsConstants.primaryBrownColor,
      ),
    ),
    leading: IconButton(
      onPressed: () =>
          state is AccountDeleting ? null : AutoRouter.of(context).back(),
      icon: const Icon(Icons.arrow_back),
    ),
  );
}
