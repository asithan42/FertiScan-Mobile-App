import 'package:fertiscanapp/util/app_lang_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import 'package:fertiscanapp/main.dart';

import 'package:fertiscanapp/controllers/language_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await GetStorage.init();
    await AppTranslationsLoader.load();
    final storage = GetStorage();
    Get.put(LanguageController(storage: storage));
  });

  testWidgets('App launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MyApp(initialLocale: Locale('en', 'US')),
    );

    // Verify that the title appears
    expect(find.text('FertiScan'), findsOneWidget);
  });
}
