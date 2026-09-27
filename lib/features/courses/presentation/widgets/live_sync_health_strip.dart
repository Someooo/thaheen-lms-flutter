import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class LiveSyncHealthStrip extends StatelessWidget {
  const LiveSyncHealthStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: StitchColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: const BoxDecoration(
                  color: StitchColors.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'data_synced_locally'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10.sp,
                  color: StitchColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(
            'hive_cache_version'.tr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10.sp,
              color: StitchColors.outline,
            ),
          ),
        ],
      ),
    );
  }
}
