import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../utils/toast_utils.dart';

class NetworkService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final RxBool _isConnected = true.obs;

  bool get isConnected => _isConnected.value;
  RxBool get isConnectedRx => _isConnected;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _initConnectivity() {
    checkConnection();

    try {
      _subscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
        onError: (e) {
          if (kDebugMode) debugPrint('Connectivity stream error: $e');
        },
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Connectivity subscription error: $e');
    }
  }

  Future<void> _handleConnectivityChange(
      List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      _updateStatus(false);
      return;
    }

    final hasInternet = await _hasRealInternetAccess();
    _updateStatus(hasInternet);
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none)) {
        _updateStatus(false);
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Connectivity check error: $e');
    }

    final hasInternet = await _hasRealInternetAccess();
    _updateStatus(hasInternet);
    return hasInternet;
  }

  Future<bool> _hasRealInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Internet lookup error: $e');
      }
      return false;
    }
  }

  void _updateStatus(bool newStatus) {
    if (_isConnected.value == newStatus) return;

    _isConnected.value = newStatus;

    if (!newStatus) {
      ToastUtils.showNoInternetSnackbar();
    } else {
      ToastUtils.showInternetRestoredSnackbar();
    }
  }
}
