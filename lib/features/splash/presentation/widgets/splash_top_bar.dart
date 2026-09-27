import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../../../../core/controllers/language_controller.dart';

class SplashTopBar extends StatelessWidget {
  const SplashTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode != 'en';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: StitchColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.offline_pin_rounded,
                size: 14.sp,
                color: StitchColors.tertiary,
              ),
              SizedBox(width: 4.w),
              Text(
                'synced_status'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: StitchColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            final langCtrl = Get.find<LanguageController>();
            langCtrl.changeLanguage(isArabic ? 'en' : 'ar');
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isArabic ? 'العربية' : 'English',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: StitchColors.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.translate_rounded,
                  size: 14.sp,
                  color: StitchColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
