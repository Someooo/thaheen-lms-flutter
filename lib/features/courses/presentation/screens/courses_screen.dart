import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/stitch_colors.dart';
import '../controllers/courses_controller.dart';
import '../widgets/clinical_identity_bar.dart';
import '../widgets/course_search_bar_with_filters.dart';
import '../widgets/courses_empty_state.dart';
import '../widgets/courses_error_state.dart';
import '../widgets/courses_header.dart';
import '../widgets/courses_loading_shimmer.dart';
import '../widgets/enrolled_courses_list.dart';
import '../widgets/live_sync_health_strip.dart';

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
              const SliverToBoxAdapter(child: CoursesHeader()),
              const SliverToBoxAdapter(child: ClinicalIdentityBar()),
              const SliverToBoxAdapter(child: LiveSyncHealthStrip()),
              const SliverToBoxAdapter(child: CourseSearchBarWithFilters()),
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
                    child: CoursesErrorState(
                      message: controller.errorMessage.value,
                      onRetry: controller.loadData,
                    ),
                  );
                }

                if (state == CoursesViewState.empty) {
                  return const SliverFillRemaining(
                    child: CoursesEmptyState(),
                  );
                }

                return SliverToBoxAdapter(
                  child: EnrolledCoursesList(controller: controller),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
