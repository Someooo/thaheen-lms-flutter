import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';
import '../widgets/player_controls_widgets.dart';

class LessonPlayerScreen extends StatelessWidget {
  const LessonPlayerScreen({super.key});

  void _showSpeedDialog(
      BuildContext context, LessonPlayerController controller) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlaybackSpeedSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LessonPlayerController>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (controller.isFullscreen.value) {
          controller.exitFullscreen();
        }
      },
      child: Scaffold(
        backgroundColor: StitchColors.inverseSurface,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: StitchColors.primary),
            );
          }

          if (controller.hasError.value) {
            return _buildErrorView(controller);
          }

          final videoController = controller.videoPlayerController;
          if (videoController == null || !videoController.value.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(color: StitchColors.primary),
            );
          }

          return Obx(() {
            final isFullscreen = controller.isFullscreen.value;

            if (isFullscreen) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    ),
                  ),
                  _buildControlsOverlay(context, controller),
                ],
              );
            }

            return Container(
              color: StitchColors.surface,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            VideoPlayer(videoController),
                            _buildControlsOverlay(context, controller),
                          ],
                        ),
                      ),
                      _buildAutoCompletionNotice(controller),
                      _buildLessonHeader(controller),
                      _buildInstructorBar(controller),
                      _buildSegmentTabs(),
                      _buildMiniSyllabusTimeline(controller),
                      _buildBottomActionButtons(controller),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }

  Widget _buildErrorView(LessonPlayerController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 48.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: StitchColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: controller.retry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: Text(
                'retry'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay(
      BuildContext context, LessonPlayerController controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.toggleControls,
      child: Obx(() {
        if (!controller.showControls.value) {
          return const SizedBox.expand();
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                StitchColors.inverseSurface.withValues(alpha: 0.75),
                Colors.transparent,
                StitchColors.inverseSurface.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTopBar(context, controller),
              _buildCenterPlayPause(controller),
              _buildBottomControlsBar(context, controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTopBar(BuildContext context, LessonPlayerController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.isFullscreen.value) {
                controller.exitFullscreen();
              } else {
                Get.back<void>();
              }
            },
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: StitchColors.inverseSurface.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: StitchColors.inverseOnSurface,
                size: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.currentLesson.value.title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.inverseOnSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'works_offline'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.tertiaryFixed,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '1080p',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: StitchColors.primaryFixed,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayPause(LessonPlayerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            final current = controller.currentPosition.value;
            final target = current - const Duration(seconds: 10);
            controller.seekTo(target < Duration.zero ? Duration.zero : target);
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.replay_10_rounded,
              color: StitchColors.inverseOnSurface,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 24.w),
        GestureDetector(
          onTap: controller.togglePlayPause,
          child: Container(
            width: 52.w,
            height: 52.w,
            decoration: const BoxDecoration(
              color: StitchColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Obx(
              () => Icon(
                controller.isPlaying.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: StitchColors.onPrimaryContainer,
                size: 34.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 24.w),
        GestureDetector(
          onTap: () {
            final current = controller.currentPosition.value;
            final total = controller.totalDuration.value;
            final target = current + const Duration(seconds: 10);
            controller.seekTo(target > total ? total : target);
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: StitchColors.inverseSurface.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.forward_10_rounded,
              color: StitchColors.inverseOnSurface,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControlsBar(
      BuildContext context, LessonPlayerController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VideoProgressBar(controller: controller),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _showSpeedDialog(context, controller),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Obx(
                    () => Text(
                      '${controller.currentSpeed.value}x',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  controller.isFullscreen.value
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
                onPressed: controller.toggleFullscreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoCompletionNotice(LessonPlayerController controller) {
    return Obx(() {
      final isComp = controller.isCompleted.value;

      return Container(
        margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: isComp
              ? StitchColors.tertiaryFixed.withValues(alpha: 0.2)
              : StitchColors.secondaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: isComp ? StitchColors.tertiary : StitchColors.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                isComp ? Icons.check_circle_rounded : Icons.verified_rounded,
                color: Colors.white,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isComp
                            ? 'auto_complete_success_title'.tr
                            : 'auto_complete_target_title'.tr,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isComp
                              ? StitchColors.tertiary
                              : StitchColors.onSecondaryContainer,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isComp
                              ? StitchColors.tertiary
                              : StitchColors.primary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          isComp ? 'status_completed'.tr : 'status_active'.tr,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    isComp
                        ? 'auto_complete_success_desc'.tr
                        : 'auto_complete_target_desc'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isComp
                          ? StitchColors.onTertiaryFixedVariant
                          : StitchColors.onSecondaryContainer,
                      fontSize: 10.sp,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLessonHeader(LessonPlayerController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Obx(
        () => Text(
          controller.currentLesson.value.title,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: StitchColors.onSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildInstructorBar(LessonPlayerController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      padding: EdgeInsets.all(10.r),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: StitchColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: StitchColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.course.instructor,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onSurface,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'instructor_title'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: StitchColors.onSurfaceVariant,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  color: StitchColors.primary,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'take_note'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.primary,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentTabs() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: StitchColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              decoration: BoxDecoration(
                color: StitchColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: StitchColors.cardShadow,
                    blurRadius: 2.r,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'tab_module_contents'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'tab_lecture_summary'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.onSurfaceVariant,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'tab_notes'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: StitchColors.onSurfaceVariant,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniSyllabusTimeline(LessonPlayerController controller) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Column(
        children: controller.orderedLessons.take(3).map((lesson) {
          final isCurrent = lesson.id == controller.currentLesson.value.id;
          final isCompleted =
              controller.progressMap[lesson.id]?.completed == true;

          return Container(
            margin: EdgeInsets.only(bottom: 6.h),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isCurrent
                  ? StitchColors.surfaceContainerLowest
                  : StitchColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? StitchColors.tertiaryContainer.withValues(alpha: 0.2)
                        : (isCurrent
                            ? StitchColors.primaryContainer
                            : StitchColors.surfaceContainerHighest),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_rounded
                        : (isCurrent
                            ? Icons.play_arrow_rounded
                            : Icons.lock_outline_rounded),
                    color: isCompleted
                        ? StitchColors.tertiary
                        : (isCurrent
                            ? StitchColors.onPrimaryContainer
                            : StitchColors.outline),
                    size: 13.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isCurrent
                              ? StitchColors.primary
                              : StitchColors.onSurface,
                          fontSize: 11.sp,
                          fontWeight:
                              isCurrent ? FontWeight.w700 : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isCurrent
                            ? 'current_playing_lecture'.tr
                            : (isCompleted
                                ? 'status_completed'.tr
                                : 'next_lesson'.tr),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: isCompleted
                              ? StitchColors.tertiary
                              : StitchColors.outline,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  lesson.duration,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.outline,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomActionButtons(LessonPlayerController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Column(
        children: [
          Obx(() {
            final next = controller.nextLesson;
            final isUnlocked = controller.isNextLessonUnlocked;

            if (next == null) return const SizedBox.shrink();

            return GestureDetector(
              onTap: isUnlocked ? controller.playNextLesson : null,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? const LinearGradient(
                          colors: [
                            StitchColors.primary,
                            StitchColors.primaryContainer,
                          ],
                        )
                      : null,
                  color: isUnlocked ? null : StitchColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: isUnlocked
                      ? [
                          BoxShadow(
                            color: StitchColors.primary.withValues(alpha: 0.25),
                            blurRadius: 8.r,
                            offset: Offset(0, 3.h),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.skip_next_rounded,
                          color: isUnlocked ? Colors.white : StitchColors.outline,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'next_lesson'.tr,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: isUnlocked
                                    ? Colors.white70
                                    : StitchColors.outline,
                                fontSize: 9.sp,
                              ),
                            ),
                            Text(
                              next.title,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: isUnlocked
                                    ? Colors.white
                                    : StitchColors.outline,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isUnlocked ? Colors.white : StitchColors.outline,
                      size: 13.sp,
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: StitchColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.download_done_rounded,
                      color: StitchColors.tertiary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'stored_in_hive_memory'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: StitchColors.onSurfaceVariant,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  'status_ready'.tr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: StitchColors.tertiary,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
