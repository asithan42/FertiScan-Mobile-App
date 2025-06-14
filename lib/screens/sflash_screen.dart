import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/screens/home_screen.dart';
import 'package:fertiscanapp/screens/language_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      final storage = GetStorage();
      final isRegistered = storage.read('isRegistered') == true;

      if (isRegistered) {
        Get.off(() => const HomeScreen());
      } else {
        Get.off(() => LanguageSelectionScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/app_logo.png',width: 120, height: 120, fit: BoxFit.cover),
              const SizedBox(height: 20),
              Text(
                'FertiScan',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: kGreenColor1,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                'Smart Fertilizer Recommendation',
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: kGreyColor2,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
