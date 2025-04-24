import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/screens/onboading_screens/onboarding_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

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
                    'onboading_screen.onboarding1.title'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: kGreenColor1,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/onboading_image1.png', // Add this image to your assets
                    height: 250,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'onboading_screen.onboarding1.description'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                        color: kBlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(isActive: true),
                      _buildDot(),
                      _buildDot(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Next button
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => OnboardingScreenTwo());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenColor2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      'onboading_screen.onboarding1.next'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot({bool isActive = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 10 : 8,
      height: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
