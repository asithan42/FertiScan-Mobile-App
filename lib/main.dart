import 'package:fertiscanapp/screens/home_screen.dart';
import 'package:fertiscanapp/util/app_lang_translations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'screens/language_selection_screen.dart';

// This is main file of the file
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Load translation files
  await AppTranslationsLoader.load();

  // Initialize GetStorage and LanguageController
  final storage = GetStorage();

  // Extract saved locale
  String savedLocale = storage.read('selectedLanguage') ?? 'en_US';
  List<String> parts = savedLocale.split('_');
  Locale initialLocale = Locale(parts[0], parts[1]);

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FertiScan',
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home:
          storage.read('isRegistered') == true
              ? HomeScreen()
              : LanguageSelectionScreen(),
    );
  }
}
