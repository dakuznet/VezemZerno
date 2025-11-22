import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';

class ProfileSettingsImageSection extends StatelessWidget {
  const ProfileSettingsImageSection({super.key, required this.isSaving, required this.isLoading, this.profileImage, this.currentImageUrl, required this.onTap});

    final bool isSaving;
  final bool isLoading;
  final io.File? profileImage;
  final String? currentImageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSaving ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        ),
        padding: EdgeInsets.all(8.w),
        width: 360.w,
        height: 120.h,
        child: isLoading
            ? const PrimaryLoadingIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: ColorsConstants.backgroundColor,
                    foregroundColor: ColorsConstants.primaryBrownColor,
                    radius: 50.r,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : (currentImageUrl != null &&
                                  currentImageUrl!.isNotEmpty
                              ? NetworkImage(currentImageUrl!)
                              : null),
                    child:
                        profileImage == null &&
                            (currentImageUrl == null ||
                                currentImageUrl!.isEmpty)
                        ? Icon(Icons.camera_alt, size: 24.w)
                        : null,
                  ),
                  Text(
                    'Изменить',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: isSaving
                          ? ColorsConstants.primaryBrownColorWithOpacity
                          : ColorsConstants.primaryBrownColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}