import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';

class CourseDetailsTopBar extends StatelessWidget {
  const CourseDetailsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back<void>(),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
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
                        Icons.arrow_back_ios_new_rounded,
                        color: StitchColors.onSurface,
                        size: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Thaheen logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'course_details_title'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onSurface,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
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
        ),
      ),
    );
  }
}
