import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/stitch_colors.dart';
import '../../../../core/controllers/language_controller.dart';
import '../controllers/courses_controller.dart';
import '../widgets/continue_watching_card.dart';
import '../widgets/course_card.dart';
import '../widgets/courses_loading_shimmer.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoursesController>();

    return Scaffold(
      backgroundColor: StitchColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: StitchColors.primary,
          onRefresh: controller.loadData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _TopHeaderBar()),
              const SliverToBoxAdapter(child: _ClinicalIdentityBar()),
              const SliverToBoxAdapter(child: _LiveSyncHealthStrip()),
              const SliverToBoxAdapter(child: _SearchAndFilters()),
              Obx(() {
                final state = controller.state.value;

                if (state == CoursesViewState.loading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: CoursesLoadingShimmer(),
                    ),
                  );
                }

                if (state == CoursesViewState.error) {
                  return SliverFillRemaining(
                    child: _ErrorState(
                      message: controller.errorMessage.value,
                      onRetry: controller.loadData,
                    ),
                  );
                }

                if (state == CoursesViewState.empty) {
                  return const SliverFillRemaining(
                    child: _EmptyState(),
                  );
                }

                return SliverToBoxAdapter(
                  child: _SuccessBody(controller: controller),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeaderBar extends StatelessWidget {
  const _TopHeaderBar();

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

class _ClinicalIdentityBar extends StatelessWidget {
  const _ClinicalIdentityBar();

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

class _LiveSyncHealthStrip extends StatelessWidget {
  const _LiveSyncHealthStrip();

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

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters();

  @override
  Widget build(BuildContext context) {
    final chips = [
      'filter_all'.tr,
      'filter_anatomy'.tr,
      'filter_physiology'.tr,
      'filter_biochemistry'.tr,
      'filter_pharmacology'.tr,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        children: [
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: StitchColors.cardShadow,
                  blurRadius: 4.r,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: StitchColors.onSurfaceVariant,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'search_hint'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                      color: StitchColors.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.tune_rounded,
                  color: StitchColors.onSurfaceVariant,
                  size: 16.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 28.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (_, __) => SizedBox(width: 6.w),
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? StitchColors.primary
                        : StitchColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Text(
                      chips[index],
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : StitchColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  final CoursesController controller;

  const _SuccessBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final continueLesson = controller.continueWatchingTarget;
      final continueCourse = controller.continueWatchingCourse;

      return Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (continueLesson != null && continueCourse != null) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_filled_rounded,
                          color: StitchColors.primary,
                          size: 18.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'continue_watching'.tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: StitchColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'active_study_session'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10.sp,
                        color: StitchColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ContinueWatchingCard(
                course: continueCourse,
                lesson: continueLesson,
                onTap: () => Get.toNamed<void>(
                  AppRoutes.courseDetails,
                  arguments: continueCourse,
                ),
              ),
            ],
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.video_library_rounded,
                        color: StitchColors.primary,
                        size: 18.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'enrolled_courses'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: StitchColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'view_all_count'.trParams({'count': '${controller.courses.length}'}),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      color: StitchColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: controller.courses.map((course) {
                  final lessons = controller.allLessonsFor(course);
                  return CourseCard(
                    course: course,
                    progress: controller.progressFor(course),
                    lessonCount: lessons.length,
                    onTap: () => Get.toNamed<void>(
                      AppRoutes.courseDetails,
                      arguments: course,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56.sp,
              color: StitchColors.outlineVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.sp,
                color: StitchColors.onSurface,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'retry'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: StitchColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 56.sp,
              color: StitchColors.outlineVariant,
            ),
            SizedBox(height: 16.h),
            Text(
              'no_courses_available'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                color: StitchColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
