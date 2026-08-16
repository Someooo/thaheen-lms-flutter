import '../../domain/entities/product_entity.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final int stock;
  final String thumbnail;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.stock,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawThumbnail = json['thumbnail'] as String? ?? '';
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      thumbnail: rawThumbnail,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .where((s) => s.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'stock': stock,
        'thumbnail': thumbnail,
        'images': images,
      };

  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        price: price,
        stock: stock,
        thumbnail: thumbnail,
        images: images,
      );
}
