import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../controllers/products_controller.dart';

class ProductsEmptyStateWidget extends StatefulWidget {
  const ProductsEmptyStateWidget({super.key});

  @override
  State<ProductsEmptyStateWidget> createState() =>
      _ProductsEmptyStateWidgetState();
}

class _ProductsEmptyStateWidgetState extends State<ProductsEmptyStateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    return Obx(() {
      final query = controller.searchQuery.value;
      final hasQuery = query.isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _bounceAnim,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _bounceAnim.value),
                  child: child,
                ),
                child: Icon(
                  hasQuery
                      ? Icons.search_off_rounded
                      : Icons.inventory_2_outlined,
                  size: 72,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                hasQuery
                    ? 'No results for "$query"'
                    : 'No products available',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasQuery
                    ? 'Try a different keyword or clear your search.'
                    : 'Check back later for new arrivals.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              if (hasQuery) ...[
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: controller.clearSearch,
                  icon: const Icon(Icons.clear_rounded,
                      size: 16, color: AppLightColors.darkBlue),
                  label: const Text(
                    'Clear search',
                    style: TextStyle(color: AppLightColors.darkBlue),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
