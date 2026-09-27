import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/network_service.dart';

class ConnectivityBannerWidget extends StatelessWidget {
  const ConnectivityBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NetworkService>()) {
      return const SizedBox.shrink();
    }

    final networkService = Get.find<NetworkService>();

    return Obx(() {
      final isConnected = networkService.isConnected;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isConnected
            ? const SizedBox.shrink()
            : Material(
                key: const ValueKey('offline_banner'),
                color: Colors.red.shade700,
                elevation: 4,
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'no_internet'.tr,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }
}
