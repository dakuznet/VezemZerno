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
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is AccountDeleted) {
              PrimarySnackBar.show(
                context: context,
                text: 'Аккаунт был успешно удалён',
                borderColor: Colors.green,
              );
              context.read<AuthBloc>().add(AuthLogoutEvent());
              AutoRouter.of(context).replace(const WelcomeRoute());
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

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Удалить аккаунт',
                        onPressed: isDeleting
                            ? null
                            : () {
                                _showDeleteAccountConfirmationDialog(context);
                              },
                      ),
                    ),
                  ),
                ),
                if (isDeleting)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColorsConstants.primaryBrownColor,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: ColorsConstants.primaryTextFormFieldBackgorundColor,
    centerTitle: true,
    title: Text(
      'Настройки',
      style: TextStyle(
        fontFamily: 'Unbounded',
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: ColorsConstants.primaryBrownColor,
      ),
    ),
    leading: IconButton(
      onPressed: () {
        AutoRouter.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back),
    ),
  );
}
