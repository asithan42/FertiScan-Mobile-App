import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'en_US'.obs;
  final GetStorage storage;

  LanguageController({required this.storage});

  @override
  void onInit() {
    super.onInit();
    // Load from storage or default to English
    selectedLanguage.value = storage.read('selectedLanguage') ?? 'en_US';
    List<String> parts = selectedLanguage.value.split('_');
    Get.updateLocale(Locale(parts[0], parts[1]));
  }

  void changeLanguage(String langCode, String countryCode) {
    final locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
    selectedLanguage.value = '${langCode}_$countryCode';
    storage.write('selectedLanguage', selectedLanguage.value);
  }
}
