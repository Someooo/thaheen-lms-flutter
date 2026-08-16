import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String title;
  final double price;
  final int stock;
  final String thumbnail;
  final List<String> images;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.stock,
    required this.thumbnail,
    required this.images,
  });

  @override
  List<Object?> get props => [id, title, price, stock, thumbnail, images];
}
