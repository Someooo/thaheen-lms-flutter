import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/product_entity.dart';
import '../controllers/products_controller.dart';

class ProductCardWidget extends StatefulWidget {
  final ProductEntity product;

  const ProductCardWidget({super.key, required this.product});

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartController;
  late final Animation<double> _heartScale;
  late final ProductsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ProductsController>();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _heartScale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onHeartTap() {
    _controller.toggleFavorite(widget.product.id);
    _heartController.forward().then((_) => _heartController.reverse());
  }

  static const int _lowStockThreshold = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    clipBehavior: Clip.hardEdge,
                    child: widget.product.thumbnail.isNotEmpty
                        ? CustomCachedImage(
                            image: widget.product.thumbnail,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image_not_supported_outlined,
                                color: Colors.grey),
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.product.stock < _lowStockThreshold
                          ? Colors.redAccent.withValues(alpha: 0.9)
                          : Colors.green.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.product.stock < _lowStockThreshold
                          ? 'Low Stock'
                          : 'In Stock',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Obx(() {
                    final fav = _controller.isFavorite(widget.product.id);
                    return GestureDetector(
                      onTap: _onHeartTap,
                      behavior: HitTestBehavior.opaque,
                      child: ScaleTransition(
                        scale: _heartScale,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            fav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.title.isNotEmpty
                      ? widget.product.title
                      : 'Unnamed Product',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppLightColors.textPrimary,
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
