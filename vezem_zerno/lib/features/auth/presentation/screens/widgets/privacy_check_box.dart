import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/routes/router.dart';

class PrivacyCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final String? errorText;

  const PrivacyCheckbox({
    super.key,
    this.initialValue = false,
    this.onChanged,
    this.errorText,
  });

  @override
  State<PrivacyCheckbox> createState() => _PrivacyCheckboxState();
}

class _PrivacyCheckboxState extends State<PrivacyCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isChecked = !_isChecked;
                });
                widget.onChanged?.call(_isChecked);
              },
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.r),
                  border: Border.all(
                    color: _isChecked
                        ? ColorsConstants.primaryBrownColor
                        : ColorsConstants.primaryBrownColorWithOpacity,
                    width: 2.w,
                  ),
                  color: _isChecked
                      ? ColorsConstants.primaryBrownColor
                      : Colors.transparent,
                ),
                child: _isChecked
                    ? Icon(Icons.check, size: 18.sp, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Я согласен с ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsConstants.primaryBrownColor,
                      ),
                      children: [
                        TextSpan(
                          text: 'политикой конфиденциальности',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorsConstants.primaryBrownColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AutoRouter.of(
                                context,
                              ).push(const PrivacyPolicyRoute());
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
