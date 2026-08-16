import '../../../../core/usecases/usecase.dart';
import '../entities/products_page_entity.dart';
import '../repositories/products_repository.dart';

class ProductsParams {
  final int limit;
  final int skip;
  final String? query;

  const ProductsParams({
    required this.limit,
    required this.skip,
    this.query,
  });
}

class GetProductsUseCase implements UseCase<ProductsPageEntity, ProductsParams> {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<ProductsPageEntity> call(ProductsParams params) =>
      repository.getProducts(
        limit: params.limit,
        skip: params.skip,
        query: params.query,
      );
}
