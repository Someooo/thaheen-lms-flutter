import '../../../../core/network/api_client.dart';
import '../models/products_response_model.dart';

abstract class ProductsRemoteDataSource {
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
    String? query,
  });
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ApiClient apiClient;

  ProductsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ProductsResponseModel> getProducts({
    required int limit,
    required int skip,
    String? query,
  }) async {
    final isSearch = query != null && query.isNotEmpty;
    final path = isSearch ? 'https://dummyjson.com/products/search' : 'https://dummyjson.com/products';
    final queryParams = <String, dynamic>{
      'limit': limit,
      'skip': skip,
    };
    if (isSearch) {
      queryParams['q'] = query;
    }

    final response = await apiClient.get(
      path,
      queryParameters: queryParams,
    );
    if (response.data != null) {
      return ProductsResponseModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Empty response from server');
    }
  }
}
