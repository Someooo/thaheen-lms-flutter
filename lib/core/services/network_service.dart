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
  bool _isInitialCheck = true;

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
    final hasInterface = results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet ||
        r == ConnectivityResult.vpn);

    if (!hasInterface) {
      _updateStatus(false);
      return;
    }

    final hasInternet = await _hasRealInternetAccess();
    _updateStatus(hasInternet);
  }

  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasInterface = results.any((r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn);

      if (!hasInterface) {
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
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(milliseconds: 2500),
      );
      socket.destroy();
      return true;
    } catch (_) {}

    try {
      final socket = await Socket.connect(
        '1.1.1.1',
        53,
        timeout: const Duration(milliseconds: 2500),
      );
      socket.destroy();
      return true;
    } catch (_) {}

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 2500));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (_) {}

    return false;
  }

  void _updateStatus(bool newStatus) {
    final wasInitial = _isInitialCheck;
    _isInitialCheck = false;

    if (!wasInitial && _isConnected.value == newStatus) return;

    final previousStatus = _isConnected.value;
    _isConnected.value = newStatus;

    if (newStatus) {
      ToastUtils.dismissSnackbar();
      if (!wasInitial && !previousStatus) {
        ToastUtils.showInternetRestoredSnackbar();
      }
    } else {
      if (!wasInitial) {
        ToastUtils.showNoInternetSnackbar();
      }
    }
  }
}
