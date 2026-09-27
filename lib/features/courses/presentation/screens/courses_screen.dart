import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/app_routes.dart';
import '../controllers/courses_controller.dart';
import '../widgets/continue_watching_card.dart';
import '../widgets/course_card.dart';
import '../widgets/courses_loading_shimmer.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoursesController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF36A9E1),
          onRefresh: controller.loadData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _Header(theme: theme)),
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
                  child: _SuccessBody(controller: controller, theme: theme),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ThemeData theme;

  const _Header({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/Thaheen logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'ذاهين',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF00679A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'دوراتي',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 26.sp,
            ),
          ),
          Text(
            'اختر دورة وابدأ التعلم',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary.withValues(alpha: 0.7),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  final CoursesController controller;
  final ThemeData theme;

  const _SuccessBody({required this.controller, required this.theme});

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
              SizedBox(height: 8.h),
              ContinueWatchingCard(
                course: continueCourse,
                lesson: continueLesson,
                onTap: () => Get.toNamed<void>(
                  AppRoutes.courseDetails,
                  arguments: continueCourse,
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'جميع الدورات',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 12.h),
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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64.sp,
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF36A9E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              size: 64.sp,
              color: theme.colorScheme.secondary.withValues(alpha: 0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              'لا توجد دورات متاحة حاليًا',
              textAlign: TextAlign.center,
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
