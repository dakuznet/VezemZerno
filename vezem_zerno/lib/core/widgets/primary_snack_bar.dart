import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';

class PrimarySnackBar {
  static OverlayEntry? _currentOverlay;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String text,
    Color? borderColor,
  }) {
    _hide();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _displayOverlay(context, text, borderColor);
    });
  }

  static void _displayOverlay(
    BuildContext context,
    String text,
    Color? borderColor,
  ) {
    try {
      final overlayState = Overlay.of(context);

      _currentOverlay = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top + 50.h,
          left: 20.w,
          right: 20.w,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                borderRadius: BorderRadius.circular(12.0.r),
                border: BoxBorder.fromLTRB(
                  left: BorderSide(color: borderColor!, width: 10.w, strokeAlign: BorderSide.strokeAlignInside),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: ColorsConstants.primaryBrownColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _hide,
                    child: Icon(
                      Icons.close,
                      size: 20.r,
                      color: ColorsConstants.primaryBrownColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      overlayState.insert(_currentOverlay!);

      _timer = Timer(const Duration(seconds: 5), _hide);
    } catch (e) {
      null;
    }
  }

  static void _hide() {
    _timer?.cancel();
    _timer = null;

    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
