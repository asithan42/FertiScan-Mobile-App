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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'user_guide_screen.instruction_title'.tr,
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
                              textKey: "user_guide_screen.instruction_1",
                            ),
                            InstructionPoint(
                              icon: "📷",
                              textKey: "user_guide_screen.instruction_2",
                            ),
                            InstructionPoint(
                              icon: "🌟",
                              textKey: "user_guide_screen.instruction_3",
                            ),
                            InstructionPoint(
                              icon: "✨",
                              textKey: "user_guide_screen.instruction_4",
                            ),
                             InstructionPoint(
                              icon: "📱",
                              textKey: "user_guide_screen.instruction_5",
                            ),
                            InstructionPoint(
                              icon: "🔄",
                              textKey: "user_guide_screen.instruction_6",
                            ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const HomeScreen());
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
                        'user_guide_screen.done_button'.tr,
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
          ),
        ],
      ),
    );
  }
}

class InstructionPoint extends StatelessWidget {
  final String icon;
  final String textKey;

  const InstructionPoint({
    super.key,
    required this.icon,
    required this.textKey,
  });

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
              textKey.tr,
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
