import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/lesson_player_controller.dart';
import 'lesson_player_bottom_controls.dart';
import 'lesson_player_center_controls.dart';
import 'lesson_player_top_bar.dart';

class LessonPlayerControlsOverlay extends StatelessWidget {
  final LessonPlayerController controller;
  final VoidCallback onSpeedTap;

  const LessonPlayerControlsOverlay({
    super.key,
    required this.controller,
    required this.onSpeedTap,
  });

  @override
  Widget build(BuildContext context) {
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
              LessonPlayerTopBar(controller: controller),
              LessonPlayerCenterControls(controller: controller),
              LessonPlayerBottomControls(
                controller: controller,
                onSpeedTap: onSpeedTap,
              ),
            ],
          ),
        );
      }),
    );
  }
}
