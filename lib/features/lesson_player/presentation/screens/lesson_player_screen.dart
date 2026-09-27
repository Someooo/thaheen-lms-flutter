import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';
import '../widgets/lesson_completion_banner.dart';
import '../widgets/lesson_mini_syllabus_timeline.dart';
import '../widgets/lesson_overview_header.dart';
import '../widgets/lesson_player_bottom_bar.dart';
import '../widgets/lesson_player_controls_overlay.dart';
import '../widgets/lesson_player_error_view.dart';
import '../widgets/lesson_player_tabs.dart';
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
            return LessonPlayerErrorView(
              errorMessage: controller.errorMessage.value,
              onRetry: controller.retry,
            );
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
                  LessonPlayerControlsOverlay(
                    controller: controller,
                    onSpeedTap: () => _showSpeedDialog(context, controller),
                  ),
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
                            LessonPlayerControlsOverlay(
                              controller: controller,
                              onSpeedTap: () =>
                                  _showSpeedDialog(context, controller),
                            ),
                          ],
                        ),
                      ),
                      LessonCompletionBanner(controller: controller),
                      LessonOverviewHeader(controller: controller),
                      const LessonPlayerTabs(),
                      LessonMiniSyllabusTimeline(controller: controller),
                      LessonPlayerBottomBar(controller: controller),
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
}
