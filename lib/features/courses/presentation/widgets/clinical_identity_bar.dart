import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../../../../core/controllers/language_controller.dart';

class ClinicalIdentityBar extends StatelessWidget {
  const ClinicalIdentityBar({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          StitchColors.primary,
                          StitchColors.primaryContainer,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(2.r),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: StitchColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          Get.locale?.languageCode == 'en' ? 'O' : 'ع',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: StitchColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        color: StitchColors.tertiary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: StitchColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'user_greeting'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: StitchColors.onSurface,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.verified_rounded,
                        color: StitchColors.primary,
                        size: 14.sp,
                      ),
                    ],
                  ),
                  Text(
                    'user_grade'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                      color: StitchColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: StitchColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.offline_pin_rounded,
                      color: StitchColors.tertiary,
                      size: 13.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'synced_status'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 9.sp,
                        color: StitchColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: () {
                  final isAr = Get.locale?.languageCode != 'en';
                  langController.changeLanguage(isAr ? 'en' : 'ar');
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: StitchColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    Get.locale?.languageCode == 'en' ? 'عربي' : 'EN',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: StitchColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
