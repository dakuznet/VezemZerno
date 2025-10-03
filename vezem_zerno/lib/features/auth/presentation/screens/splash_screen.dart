import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
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
  static const _minLoadingDuration = Duration(seconds: 1);
  static const _retryDelay = Duration(seconds: 5);
  static const _initialCheckDelay = Duration(seconds: 1);

  bool _hasNavigated = false;
  bool _isMinimumLoadingTimePassed = false;
  Timer? _retryTimer;
  Timer? _minimumLoadingTimer;
  bool _didCacheImages = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _startMinimumLoadingTimer();
    _scheduleInitialCheck();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_hasNavigated) {
      _startMinimumLoadingTimer();
      _scheduleInitialCheck();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didCacheImages) {
      precacheImage(
        const AssetImage('assets/png/logo.png'),
        context,
        size: Size(230.w, 230.h),
      );
      precacheImage(const AssetImage('assets/png/wheat.png'), context);
      _didCacheImages = true;
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _minimumLoadingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthStateChange,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(AuthState state) {
    if (!_isMinimumLoadingTimePassed) {
      return _buildLoadingIndicator();
    }

    if (state is NoInternetConnection) {
      return _buildNoInternetConnection();
    }

    if (state is AuthFailure && !_hasNavigated) {}

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
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 64.sp,
              color: ColorsConstants.primaryBrownColor,
            ),
            SizedBox(height: 24.h),
            Text(
              'Отсутствует соединение с интернетом',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: ColorsConstants.primaryBrownColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startMinimumLoadingTimer() {
    _isMinimumLoadingTimePassed = false;
    _minimumLoadingTimer?.cancel();

    _minimumLoadingTimer = Timer(_minLoadingDuration, () {
      if (mounted) {
        setState(() {
          _isMinimumLoadingTimePassed = true;
        });
      }
    });
  }

  void _scheduleInitialCheck() {
    if (_hasNavigated || !mounted) return;

    _retryTimer?.cancel();

    Future.delayed(_initialCheckDelay, () {
      if (mounted) {
        context.read<AuthBloc>().add(RestoreSessionEvent());
        _scheduleRetryCheck();
      }
    });
  }

  void _scheduleRetryCheck() {
    if (_hasNavigated || !mounted) return;

    _retryTimer = Timer(_retryDelay, () {
      if (!mounted || _hasNavigated) return;

      final currentState = context.read<AuthBloc>().state;
      if (currentState is NoInternetConnection) {
        _startMinimumLoadingTimer();
        context.read<AuthBloc>().add(RestoreSessionEvent());
        _scheduleRetryCheck();
      }
    });
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (_hasNavigated || !mounted) return;

    if (state is SessionRestored || state is LoginSuccess) {
      _hasNavigated = true;
      _retryTimer?.cancel();
      _minimumLoadingTimer?.cancel();
      AutoRouter.of(context).replaceAll([const MainRoute()]);
    } else if (state is Unauthenticated || state is AuthFailure) {
      _hasNavigated = true;
      _retryTimer?.cancel();
      _minimumLoadingTimer?.cancel();
      if (state is AuthFailure) {
        setState(() {});
      } else {
        AutoRouter.of(context).replaceAll([const WelcomeRoute()]);
      }
    }
  }
}
