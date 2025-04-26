import 'package:fertiscanapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/colors.dart';

class PhotoTakeInstruction extends StatefulWidget {
  const PhotoTakeInstruction({super.key});

  @override
  State<PhotoTakeInstruction> createState() => _PhotoTakeInstructionState();
}

class _PhotoTakeInstructionState extends State<PhotoTakeInstruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Instructions for taking LCC chart image',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: kGreenColor1,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/lcc_chart_screen_image.png',
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          InstructionPoint(
                            icon: "📄",
                            text:
                                "Place a white paper under the rice leaf for better contrast.",
                          ),
                          InstructionPoint(
                            icon: "📷",
                            text:
                                "Take a clear photo with the leaf fully visible.",
                          ),
                          InstructionPoint(
                            icon: "🌟",
                            text:
                                "Use natural light and avoid shadows or direct flash.",
                          ),
                          InstructionPoint(
                            icon: "✨",
                            text:
                                "Capture the image in good lighting, preferably outdoors.",
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to scanning screen
                      Get.to(() => HomeScreen());
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
                      'Done',
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
            ),
          ),
        ],
      ),
    );
  }
}

class InstructionPoint extends StatelessWidget {
  final String icon;
  final String text;

  const InstructionPoint({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: kBlackColor,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
