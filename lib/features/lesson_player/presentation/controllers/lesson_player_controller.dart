import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../courses/data/datasources/lesson_progress_local_data_source.dart';
import '../../../courses/data/models/lesson_progress_model.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../courses/domain/entities/lesson.dart';
import '../../../courses/domain/logic/lesson_progress_logic.dart';

class LessonPlayerController extends GetxController {
  final LessonProgressLocalDataSource _progressDataSource;

  LessonPlayerController({
    required LessonProgressLocalDataSource progressDataSource,
  }) : _progressDataSource = progressDataSource;

  late Course course;
  late Rx<Lesson> currentLesson;
  late List<Lesson> orderedLessons;

  VideoPlayerController? videoPlayerController;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isCompleted = false.obs;
  final RxBool isFullscreen = false.obs;
  final RxDouble currentSpeed = 1.0.obs;

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;

  final RxMap<String, LessonProgressModel> progressMap =
      <String, LessonProgressModel>{}.obs;

  final RxBool showControls = true.obs;
  Timer? _controlsTimer;
  Timer? _periodicSaveTimer;

  int _lastSavedSeconds = -1;

  final List<double> availableSpeeds = const [1.0, 1.25, 1.5, 2.0];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    course = args['course'] as Course;
    final initialLesson = args['lesson'] as Lesson;
    currentLesson = initialLesson.obs;

    orderedLessons = course.sections
        .expand((s) => s.lessons)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    _loadAllProgress().then((_) {
      _initializeLesson(currentLesson.value);
    });
  }

  Future<void> _loadAllProgress() async {
    try {
      final all = await _progressDataSource.getAllLessonProgress();
      progressMap.assignAll({for (final p in all) p.lessonId: p});
    } catch (_) {
      progressMap.clear();
    }
  }

  Future<void> _initializeLesson(Lesson lesson) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    isPlaying.value = false;

    await _disposeCurrentVideo();

    final savedProgress = progressMap[lesson.id];
    isCompleted.value = savedProgress?.completed == true;

    try {
      final controller = VideoPlayerController.asset(lesson.videoAsset);
      videoPlayerController = controller;

      await controller.initialize();

      totalDuration.value = controller.value.duration;

      final savedSeconds = savedProgress?.position ?? 0;
      final videoSeconds = controller.value.duration.inSeconds;
      final targetSeconds =
          savedSeconds > videoSeconds ? videoSeconds : savedSeconds;

      if (targetSeconds > 0 && targetSeconds < videoSeconds) {
        await controller.seekTo(Duration(seconds: targetSeconds));
        currentPosition.value = Duration(seconds: targetSeconds);
      } else {
        currentPosition.value = Duration.zero;
      }

      await controller.setPlaybackSpeed(currentSpeed.value);

      controller.addListener(_videoListener);

      isLoading.value = false;

      await controller.play();
      isPlaying.value = true;

      _startPeriodicSave();
      _startControlsTimer();
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'error_playing_video'.tr;
    }
  }

  void _videoListener() {
    final controller = videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    isPlaying.value = controller.value.isPlaying;
    currentPosition.value = controller.value.position;
    totalDuration.value = controller.value.duration;

    final posSec = controller.value.position.inSeconds;
    if (!isCompleted.value &&
        hasReachedCompletionThreshold(posSec, currentLesson.value.duration)) {
      _markCompleted();
    }

    if (posSec >= controller.value.duration.inSeconds &&
        controller.value.duration.inSeconds > 0) {
      if (!isCompleted.value) {
        _markCompleted();
      }
    }
  }

  Future<void> _markCompleted() async {
    isCompleted.value = true;
    final lessonId = currentLesson.value.id;
    final posSec = currentPosition.value.inSeconds;

    final updated = LessonProgressModel(
      lessonId: lessonId,
      position: posSec,
      completed: true,
    );

    progressMap[lessonId] = updated;
    await _progressDataSource.saveLessonProgress(updated);
  }

  void _startPeriodicSave() {
    _periodicSaveTimer?.cancel();
    _periodicSaveTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _saveCurrentPosition(force: false);
    });
  }

  Future<void> _saveCurrentPosition({bool force = false}) async {
    final controller = videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    final currentSec = controller.value.position.inSeconds;
    if (!force && (currentSec - _lastSavedSeconds).abs() < 3) {
      return;
    }

    _lastSavedSeconds = currentSec;
    final lessonId = currentLesson.value.id;
    final existing = progressMap[lessonId];
    final completed = isCompleted.value || (existing?.completed == true);

    final progress = LessonProgressModel(
      lessonId: lessonId,
      position: currentSec,
      completed: completed,
    );

    progressMap[lessonId] = progress;
    try {
      await _progressDataSource.saveLessonProgress(progress);
    } catch (_) {}
  }

  Future<void> togglePlayPause() async {
    final controller = videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();
      isPlaying.value = false;
      await _saveCurrentPosition(force: true);
    } else {
      await controller.play();
      isPlaying.value = true;
    }
    resetControlsTimer();
  }

  Future<void> seekTo(Duration position) async {
    final controller = videoPlayerController;
    if (controller == null || !controller.value.isInitialized) return;

    final clampedMs = position.inMilliseconds.clamp(
      0,
      controller.value.duration.inMilliseconds,
    );
    final target = Duration(milliseconds: clampedMs);
    await controller.seekTo(target);
    currentPosition.value = target;
    await _saveCurrentPosition(force: true);
    resetControlsTimer();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    final controller = videoPlayerController;
    if (controller == null) return;
    currentSpeed.value = speed;
    await controller.setPlaybackSpeed(speed);
    resetControlsTimer();
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value) {
      resetControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  void resetControlsTimer() {
    _controlsTimer?.cancel();
    _startControlsTimer();
  }

  void _startControlsTimer() {
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      if (isPlaying.value) {
        showControls.value = false;
      }
    });
  }

  Future<void> toggleFullscreen() async {
    if (isFullscreen.value) {
      await exitFullscreen();
    } else {
      await enterFullscreen();
    }
  }

  Future<void> enterFullscreen() async {
    isFullscreen.value = true;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> exitFullscreen() async {
    isFullscreen.value = false;
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Lesson? get nextLesson {
    final currentIndex =
        orderedLessons.indexWhere((l) => l.id == currentLesson.value.id);
    if (currentIndex < 0 || currentIndex + 1 >= orderedLessons.length) {
      return null;
    }
    return orderedLessons[currentIndex + 1];
  }

  bool get isNextLessonUnlocked {
    final next = nextLesson;
    if (next == null) return false;
    return isLessonUnlocked(next, orderedLessons, progressMap);
  }

  Future<void> playNextLesson() async {
    final next = nextLesson;
    if (next == null) return;
    if (!isNextLessonUnlocked) return;

    await _saveCurrentPosition(force: true);
    currentLesson.value = next;
    _lastSavedSeconds = -1;
    await _initializeLesson(next);
  }

  Future<void> retry() async {
    await _initializeLesson(currentLesson.value);
  }

  Future<void> _disposeCurrentVideo() async {
    _periodicSaveTimer?.cancel();
    _controlsTimer?.cancel();
    final controller = videoPlayerController;
    if (controller != null) {
      controller.removeListener(_videoListener);
      await controller.dispose();
      videoPlayerController = null;
    }
  }

  @override
  void onClose() {
    _saveCurrentPosition(force: true);
    _disposeCurrentVideo();
    if (isFullscreen.value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    super.onClose();
  }
}
