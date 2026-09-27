import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:my_template/core/localization/app_translations.dart';
import 'package:my_template/core/services/network_service.dart';
import 'package:my_template/core/widgets/connectivity_banner_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.put<NetworkService>(NetworkService());
  });

  testWidgets('ConnectivityBannerWidget shows banner when offline',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: AppTranslations(),
        locale: const Locale('en'),
        home: const Scaffold(
          body: Column(
            children: [
              ConnectivityBannerWidget(),
              Text('App Body'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('No internet connection'), findsNothing);

    final networkService = Get.find<NetworkService>();
    networkService.isConnectedRx.value = false;
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsOneWidget);

    networkService.isConnectedRx.value = true;
    await tester.pumpAndSettle();

    expect(find.text('No internet connection'), findsNothing);
  });
}
