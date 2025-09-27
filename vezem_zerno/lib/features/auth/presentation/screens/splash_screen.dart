import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_button.dart';
import 'package:vezem_zerno/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vezem_zerno/routes/router.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  bool _hasNavigated = false;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_hasNavigated) {
      _checkSession();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _hasNavigated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          _handleAuthState(context, state);
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(AuthState state) {
    if (state is NoInternetConnection) {
      return _buildNoInternetConnection();
    }

    if (state is AuthFailure && !_hasNavigated) {
      return _buildAuthError(state);
    }

    return _buildLoadingIndicator();
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 4.w,
            backgroundColor:
                ColorsConstants.primaryTextFormFieldBackgorundColor,
            color: ColorsConstants.primaryBrownColor,
          ),
          SizedBox(height: 24.h),
          Text(
            'Загрузка...',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetConnection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 50.sp,
              color: ColorsConstants.primaryBrownColorWithOpacity,
            ),
            SizedBox(height: 24.h),
            Text(
              'Отсутствует соединение с интернетом',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(16).r,
              child: PrimaryButton(
                text: 'Повторить',
                onPressed: _retryConnection,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthError(AuthFailure state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 80.sp, color: Colors.red),
            SizedBox(height: 24.h),
            Text(
              'Ошибка авторизации',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: ColorsConstants.primaryBrownColorWithOpacity,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: _navigateToWelcome,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsConstants.primaryBrownColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Text(
                'Войти заново',
                style: TextStyle(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkSession() {
    if (_hasNavigated || !mounted) return;

    _authSubscription?.cancel();

    _authSubscription = context.read<AuthBloc>().stream.listen((state) {
      if (mounted) {
        _handleAuthState(context, state);
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        context.read<AuthBloc>().add(RestoreSessionEvent());
      }
    });

    if (!_hasNavigated) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && !_hasNavigated) {
          final currentState = context.read<AuthBloc>().state;
          if (currentState is NoInternetConnection) {
            _checkSession();
          }
        }
      });
    }
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (_hasNavigated || !mounted) return;

    if (state is SessionRestored || state is LoginSuccess) {
      _hasNavigated = true;
      _navigateToMap();
    } else if (state is Unauthenticated || state is AuthFailure) {
      _hasNavigated = true;
      if (state is AuthFailure) {
        setState(() {});
      } else {
        _navigateToWelcome();
      }
    }
  }

  void _navigateToMap() {
    if (!mounted) return;
    context.router.replaceAll([const MainRoute()]);
  }

  void _navigateToWelcome() {
    if (!mounted) return;
    context.router.replaceAll([const WelcomeRoute()]);
  }

  void _retryConnection() {
    if (!mounted) return;
    _hasNavigated = false;
    _checkSession();
  }
}
