import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/lesson_player_controller.dart';
import '../widgets/player_controls_widgets.dart';

class LessonPlayerScreen extends StatelessWidget {
  const LessonPlayerScreen({super.key});

  void _showSpeedDialog(BuildContext context, LessonPlayerController controller) {
    showModalBottomSheet<void>(
      context: context,
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
        backgroundColor: Colors.black,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF36A9E1)),
            );
          }

          if (controller.hasError.value) {
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
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF36A9E1),
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
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final videoController = controller.videoPlayerController;
          if (videoController == null || !videoController.value.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF36A9E1)),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: videoController.value.aspectRatio,
                  child: VideoPlayer(videoController),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.toggleControls,
                child: Obx(() {
                  if (!controller.showControls.value) {
                    return const SizedBox.expand();
                  }

                  return Container(
                    color: Colors.black.withValues(alpha: 0.45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTopBar(context, controller),
                        _buildCenterPlayPause(controller),
                        _buildBottomBar(context, controller),
                      ],
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, LessonPlayerController controller) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(
                () => Text(
                  controller.currentLesson.value.title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Obx(
              () => controller.isCompleted.value
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: const Color(0xFF4CAF50),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_rounded,
                              size: 12.sp, color: const Color(0xFF4CAF50)),
                          SizedBox(width: 4.w),
                          Text(
                            'status_completed'.tr,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: const Color(0xFF4CAF50),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterPlayPause(LessonPlayerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 52.sp,
          icon: Icon(
            controller.isPlaying.value
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_filled_rounded,
            color: Colors.white,
          ),
          onPressed: controller.togglePlayPause,
        ),
      ],
    );
  }

  Widget _buildBottomBar(
      BuildContext context, LessonPlayerController controller) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VideoProgressBar(controller: controller),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showSpeedDialog(context, controller),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Obx(
                      () => Text(
                        '${controller.currentSpeed.value}x',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Obx(() {
                  final next = controller.nextLesson;
                  final isUnlocked = controller.isNextLessonUnlocked;

                  if (next == null) return const SizedBox.shrink();

                  return TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: isUnlocked
                          ? const Color(0xFF36A9E1)
                          : Colors.white38,
                    ),
                    onPressed: isUnlocked ? controller.playNextLesson : null,
                    icon: Icon(
                      Icons.skip_next_rounded,
                      size: 20.sp,
                    ),
                    label: Text(
                      'next_lesson'.tr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
                IconButton(
                  icon: Icon(
                    controller.isFullscreen.value
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  onPressed: controller.toggleFullscreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
