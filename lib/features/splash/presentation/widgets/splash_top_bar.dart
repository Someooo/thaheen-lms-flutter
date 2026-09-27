import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../../../../core/controllers/language_controller.dart';

import '../../../../core/services/network_service.dart';

class SplashTopBar extends StatelessWidget {
  const SplashTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Get.locale?.languageCode != 'en';
    final hasNetworkService = Get.isRegistered<NetworkService>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasNetworkService)
          Obx(() {
            final isConnected = Get.find<NetworkService>().isConnected;
            return Container(
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
                    isConnected
                        ? Icons.offline_pin_rounded
                        : Icons.wifi_off_rounded,
                    size: 14.sp,
                    color: isConnected
                        ? StitchColors.tertiary
                        : Colors.orange.shade800,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    isConnected ? 'synced_status'.tr : 'no_internet'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isConnected
                          ? StitchColors.onSurfaceVariant
                          : Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            );
          })
        else
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
