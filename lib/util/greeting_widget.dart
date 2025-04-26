import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'greetings.morning'.tr;
    } else if (hour < 17) {
      return 'greetings.afternoon'.tr;
    } else if (hour < 21) {
      return 'greetings.evening'.tr;
    } else {
      return 'greetings.night'.tr;
    }
  }

  String _getUserName() {
    final storage = GetStorage();
    return storage.read('userName') ?? 'farmer';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kGreenColor2,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Text(
        textAlign: TextAlign.center,
       '${_getGreetingMessage()}\n${'hamburger_menu.dear'.tr} ${_getUserName()}!',
        style: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}