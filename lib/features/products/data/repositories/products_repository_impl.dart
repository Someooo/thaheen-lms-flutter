import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/products_page_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_data_source.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductsPageEntity> getProducts({
    required int limit,
    required int skip,
    String? query,
  }) async {
    try {
      final responseModel = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
        query: query,
      );
      return responseModel.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
