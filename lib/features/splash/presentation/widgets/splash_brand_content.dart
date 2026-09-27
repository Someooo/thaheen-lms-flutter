import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class SplashBrandContent extends StatelessWidget {
  const SplashBrandContent({super.key});

  Widget _buildPill({required Color dotColor, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: StitchColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: StitchColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: StitchColors.primaryFixed.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.school_rounded,
                size: 13.sp,
                color: StitchColors.onPrimaryFixedVariant,
              ),
              SizedBox(width: 4.w),
              Text(
                'splash_portal_tag'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: StitchColors.onPrimaryFixedVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'splash_brand_title'.tr,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: StitchColors.onSurface,
          ),
        ),
        Container(
          width: 44.w,
          height: 3.5.h,
          margin: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: const LinearGradient(
              colors: [
                StitchColors.primaryContainer,
                StitchColors.tertiaryContainer,
              ],
            ),
          ),
        ),
        Text(
          'splash_field_title'.tr,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: StitchColors.primary,
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'splash_desc'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              height: 1.4,
              color: StitchColors.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildPill(
              dotColor: StitchColors.primary,
              title: 'spec_medicine'.tr,
            ),
            _buildPill(
              dotColor: StitchColors.tertiary,
              title: 'spec_nursing'.tr,
            ),
            _buildPill(
              dotColor: StitchColors.secondary,
              title: 'spec_pharmacy'.tr,
            ),
            _buildPill(
              dotColor: StitchColors.primaryContainer,
              title: 'spec_prep'.tr,
            ),
          ],
        ),
      ],
    );
  }
}
