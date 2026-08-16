import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../controllers/products_controller.dart';
import 'product_card_widget.dart';
import 'products_pagination_loader.dart';

class ProductsGridWidget extends StatelessWidget {
  const ProductsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    return RefreshIndicator(
      color: AppLightColors.darkBlue,
      backgroundColor: Colors.white,
      onRefresh: controller.refreshProducts,
      child: CustomScrollView(
        controller: controller.scrollController,
        cacheExtent: 1000,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: Obx(
              () => SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ProductCardWidget(product: controller.products[index]),
                  childCount: controller.products.length,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => ProductsPaginationLoader(
                isLoadingMore: controller.isLoadingMore.value,
                hasMore: controller.hasMore.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
