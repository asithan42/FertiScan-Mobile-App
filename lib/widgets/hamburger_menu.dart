import 'package:fertiscanapp/models/fertilizer_session.dart';
import 'package:fertiscanapp/screens/history_screen.dart';
import 'package:fertiscanapp/screens/photo_take_instruction.dart';
import 'package:fertiscanapp/widgets/name_required_message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add GetX import
import 'package:get_storage/get_storage.dart'; // For persistent storage
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constant/colors.dart';

class HamburgerMenu extends StatefulWidget {
  final VoidCallback? onClose;

  const HamburgerMenu({super.key, this.onClose});

  @override
  State<HamburgerMenu> createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  bool _showLanguages = false;
  final storage = GetStorage();
  List<FertilizerSession> _historySessions = [];
  String? _appVersion;
  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadAppVersion();
  }

  // Load app version using PackageInfo
  void _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'Version ${info.version}';
    });
  }

  void _loadHistory() {
    final sessions = storage.read<List>('fertilizerSessions') ?? [];
    _historySessions =
        sessions.map((e) => FertilizerSession.fromMap(e)).toList();
    setState(() {});
  }

  // Get greeting message based on the current time
  String _getUserName() {
    return GetStorage().read('userName') ?? 'farmer';
  }

  // Get current language based on Get.locale
  String get _selectedLanguage {
    final locale = Get.locale;
    if (locale?.languageCode == 'si') return 'සිංහල';
    if (locale?.languageCode == 'ta') return 'தமிழ்';
    return 'English'; // default
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'hamburger_menu.hi'.tr}\n${'hamburger_menu.dear'.tr} ${_getUserName()}!',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kGreenColor1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(
                      Icons.close,
                      color: kBlackColor,
                      size: 30,
                      weight: 50,
                    ),
                    tooltip: 'Close',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showLanguages = !_showLanguages;
                });
              },
              child: Text(
                'hamburger_menu.change_lang'.tr,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: kGreenColor1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_showLanguages) ...[
              _buildLanguageButton('සිංහල', 'si', 'LK'),
              _buildLanguageButton('English', 'en', 'US'),
              _buildLanguageButton('தமிழ்', 'ta', 'IN'),
              const SizedBox(height: 16),
            ],
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                NameInputDialog.show(context, initialName: _getUserName());
              },
              icon: const Icon(Icons.person, color: kBlackColor),
              label: Text(
                'hamburger_menu.change_name'.tr,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: kGreenColor1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                Get.to(PhotoTakeInstruction());
              },
              icon: const Icon(Icons.menu_book, color: kBlackColor),
              label: Text(
                'hamburger_menu.user_guide'.tr,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: kGreenColor1,
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Add new history button
            TextButton.icon(
              onPressed: () {
                Get.to(() => HistoryScreen());
                widget.onClose?.call();
              },
              icon: const Icon(Icons.history, color: kBlackColor),
              label: Text(
                'hamburger_menu.recommendation_history'.tr,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: kGreenColor1,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _appVersion ?? 'Loading...',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    String text,
    String languageCode,
    String countryCode,
  ) {
    final bool isSelected = text == _selectedLanguage;
    return GestureDetector(
      onTap: () {
        // Save to storage and change app language
        storage.write('selectedLanguage', '${languageCode}_$countryCode');
        Get.updateLocale(Locale(languageCode, countryCode));
        setState(() {
          _showLanguages = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? kGreenColor2 : kGreenColor1.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
