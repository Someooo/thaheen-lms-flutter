import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class CoursesHeader extends StatelessWidget {
  const CoursesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Thaheen logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'app_title'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'home_subtitle'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onSurfaceVariant,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: StitchColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: StitchColors.cardShadow,
                      blurRadius: 4.r,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: StitchColors.onSurfaceVariant,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: StitchColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: StitchColors.onPrimary,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
