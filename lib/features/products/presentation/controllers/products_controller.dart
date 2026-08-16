import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductsController extends GetxController {
  final GetProductsUseCase getProductsUseCase;

  ProductsController({required this.getProductsUseCase});

  late final ScrollController scrollController;
  late final TextEditingController searchController;
  Timer? _debounceTimer;
  Timer? _retryTimer;
  bool _scrollFetchPending = false;

  final RxList<ProductEntity> _products = <ProductEntity>[].obs;
  RxList<ProductEntity> get products => _products;

  final RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  final RxBool _isLoadingMore = false.obs;
  RxBool get isLoadingMore => _isLoadingMore;

  final RxString _errorMessage = ''.obs;
  RxString get errorMessage => _errorMessage;

  final RxBool _hasMore = true.obs;
  RxBool get hasMore => _hasMore;

  final RxString searchQuery = ''.obs;

  final RxInt retryCountdown = 0.obs;

  final RxSet<int> _favorites = <int>{}.obs;
  RxSet<int> get favorites => _favorites;

  final RxMap<int, int> _cartItems = <int, int>{}.obs;
  RxMap<int, int> get cartItems => _cartItems;

  bool isFavorite(int productId) => _favorites.contains(productId);

  void toggleFavorite(int productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
  }

  int get totalCartCount =>
      _cartItems.values.fold(0, (sum, count) => sum + count);

  final int limit = 10;
  int currentSkip = 0;
  int total = 0;
  int _retryAttempt = 0;
  static const int _maxAutoRetries = 3;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    searchController = TextEditingController();
    fetchInitialProducts();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounceTimer?.cancel();
    _retryTimer?.cancel();
    super.onClose();
  }

  void _onScroll() {
    if (_scrollFetchPending) return;
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _scrollFetchPending = true;
      fetchMoreProducts().whenComplete(() => _scrollFetchPending = false);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query.trim();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchInitialProducts();
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _debounceTimer?.cancel();
    fetchInitialProducts();
  }

  Future<void> fetchInitialProducts() async {
    if (_isLoading.value) return;
    _retryTimer?.cancel();
    _retryAttempt = 0;
    retryCountdown.value = 0;

    _isLoading.value = true;
    _errorMessage.value = '';
    currentSkip = 0;
    _hasMore.value = true;

    try {
      final page = await getProductsUseCase.call(
        ProductsParams(
          limit: limit,
          skip: currentSkip,
          query: searchQuery.value.isEmpty ? null : searchQuery.value,
        ),
      );
      _products.assignAll(page.products);
      total = page.total;
      currentSkip = page.skip + limit;
      _hasMore.value = _products.length < total;
    } catch (e) {
      _handleFetchError(e, isInitial: true);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> fetchMoreProducts() async {
    if (_isLoading.value ||
        _isLoadingMore.value ||
        !_hasMore.value ||
        _products.length >= total) {
      return;
    }

    _isLoadingMore.value = true;
    _errorMessage.value = '';

    try {
      final page = await getProductsUseCase.call(
        ProductsParams(
          limit: limit,
          skip: currentSkip,
          query: searchQuery.value.isEmpty ? null : searchQuery.value,
        ),
      );
      _products.addAll(page.products);
      total = page.total;
      currentSkip = page.skip + limit;
      _hasMore.value = _products.length < total;
    } catch (e) {
      _handleFetchError(e, isInitial: false);
    } finally {
      _isLoadingMore.value = false;
    }
  }

  void _handleFetchError(Object e, {required bool isInitial}) {
    if (e is Failure) {
      _errorMessage.value = e.message ?? 'Failed to load products';
    } else {
      _errorMessage.value = e.toString();
    }

    if (e is NetworkFailure && isInitial && _retryAttempt < _maxAutoRetries) {
      _scheduleAutoRetry();
    }
  }

  void _scheduleAutoRetry() {
    final delaySeconds = 1 << _retryAttempt;
    _retryAttempt++;
    retryCountdown.value = delaySeconds;

    _retryTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      retryCountdown.value--;
      if (retryCountdown.value <= 0) {
        t.cancel();
        fetchInitialProducts();
      }
    });
  }

  void addToCart(ProductEntity product) {
    _cartItems[product.id] = (_cartItems[product.id] ?? 0) + 1;
    Get.closeAllSnackbars();
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void removeFromCart(int productId) {
    if (_cartItems.containsKey(productId)) {
      final currentQuantity = _cartItems[productId] ?? 0;
      if (currentQuantity <= 1) {
        _cartItems.remove(productId);
      } else {
        _cartItems[productId] = currentQuantity - 1;
      }
    }
  }

  Future<void> refreshProducts() async {
    _debounceTimer?.cancel();
    await fetchInitialProducts();
  }
}
