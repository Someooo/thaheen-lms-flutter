import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../controllers/products_controller.dart';
import '../widgets/products_empty_state_widget.dart';
import '../widgets/products_error_widget.dart';
import '../widgets/products_grid_widget.dart';
import '../widgets/products_search_bar_widget.dart';
import '../widgets/products_shimmer_grid.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: const [],
      ),
      body: const Column(
        children: [
          ProductsSearchBarWidget(),
          Expanded(child: _ProductsBody()),
        ],
      ),
    );
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    return Obx(() {
      final loading = controller.isLoading.value;
      final empty = controller.products.isEmpty;

      if (loading && empty) {
        return const ProductsShimmerGrid();
      }

      if (empty) {
        return RefreshIndicator(
          color: AppLightColors.darkBlue,
          backgroundColor: Colors.white,
          onRefresh: controller.refreshProducts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: controller.errorMessage.isNotEmpty
                    ? ProductsErrorWidget(
                        message: controller.errorMessage.value,
                        onRetry: controller.fetchInitialProducts,
                      )
                    : const ProductsEmptyStateWidget(),
              ),
            ],
          ),
        );
      }

      return const ProductsGridWidget();
    });
  }
}
