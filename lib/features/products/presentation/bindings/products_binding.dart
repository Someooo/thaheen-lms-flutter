import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/products_remote_data_source.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../controllers/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut<ApiClient>(() => ApiClient());
    }

    Get.lazyPut<ProductsRemoteDataSource>(
      () => ProductsRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<ProductsRepository>(
      () => ProductsRepositoryImpl(Get.find<ProductsRemoteDataSource>()),
    );
    Get.lazyPut<GetProductsUseCase>(
      () => GetProductsUseCase(Get.find<ProductsRepository>()),
    );
    Get.lazyPut<ProductsController>(
      () => ProductsController(getProductsUseCase: Get.find<GetProductsUseCase>()),
    );
  }
}
