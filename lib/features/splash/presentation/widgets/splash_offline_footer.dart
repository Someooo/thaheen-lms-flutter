import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class SplashOfflineFooter extends StatelessWidget {
  const SplashOfflineFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_done_rounded,
            size: 14.sp,
            color: StitchColors.tertiary,
          ),
          SizedBox(width: 6.w),
          Text(
            'splash_offline_compat'.tr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: StitchColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
