import '../entities/products_page_entity.dart';

abstract class ProductsRepository {
  Future<ProductsPageEntity> getProducts({
    required int limit,
    required int skip,
    String? query,
  });
}
