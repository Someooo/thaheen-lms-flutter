import '../../domain/entities/products_page_entity.dart';
import 'product_model.dart';

class ProductsResponseModel {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponseModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductsResponseModel(
        products: (json['products'] as List<dynamic>?)
                ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        total: json['total'] as int? ?? 0,
        skip: json['skip'] as int? ?? 0,
        limit: json['limit'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'products': products.map((e) => e.toJson()).toList(),
        'total': total,
        'skip': skip,
        'limit': limit,
      };

  ProductsPageEntity toEntity() => ProductsPageEntity(
        products: products.map((e) => e.toEntity()).toList(),
        total: total,
        skip: skip,
        limit: limit,
      );
}
