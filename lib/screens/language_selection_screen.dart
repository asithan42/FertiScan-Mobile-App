import 'package:fertiscanapp/screens/onboarding_screen_1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/language_controller.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final LanguageController controller = Get.put(
    LanguageController(storage: GetStorage()),
  );

  // Map: Display Name -> {langCode, countryCode}
  final Map<String, Map<String, String>> languages = {
    'සිංහල': {'lang': 'si', 'country': 'LK'},
    'English': {'lang': 'en', 'country': 'US'},
    'தமிழ்': {'lang': 'ta', 'country': 'IN'},
  };

  LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'FertiScan',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/language_screen_image.png',
                    height: 250,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'onboading_screen.select_language'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),

                  // Language Chips
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          languages.entries.map((entry) {
                            final displayName = entry.key;
                            final langCode = entry.value['lang']!;
                            final countryCode = entry.value['country']!;
                            final isSelected =
                                controller.selectedLanguage.value ==
                                '${langCode}_$countryCode';

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: ChoiceChip(
                                label: Text(displayName),
                                selected: isSelected,
                                selectedColor: Colors.green[700],
                                backgroundColor: Colors.green[100],
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                                onSelected: (_) {
                                  controller.changeLanguage(
                                    langCode,
                                    countryCode,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  Get.to(() => OnboardingScreen1());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: Text(
                  'onboading_screen.continue'.tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
