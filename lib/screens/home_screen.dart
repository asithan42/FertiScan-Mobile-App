import 'package:fertiscanapp/screens/photo_take_instruction.dart';
import 'package:fertiscanapp/util/capture_progress.dart';
import 'package:fertiscanapp/util/greeting_widget.dart';
import 'package:fertiscanapp/widgets/hamburger_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF0), // soft greenish white
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hamburger menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black87),
                        onPressed: () {
                          setState(() {
                            _isMenuOpen = true;
                          });
                        },
                      ),
                    ],
                  ).animate().slideX(duration: 600.ms).fadeIn(),

                  const SizedBox(height: 10),

                  // Greeting box
                  const GreetingWidget().animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 20),

                  // Instruction text
                  Center(
                    child:
                        Text(
                          'home_screen.instruction_text'.tr,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideY(),
                  ),

                  const SizedBox(height: 30),

                  // Home illustration
                  Center(
                    child:
                        ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/images/farmer_home_page.png',
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                            .animate()
                            .scale(
                              duration: 600.ms,
                              begin: const Offset(0.8, 0.8),
                            )
                            .fadeIn(),
                  ),

                  const SizedBox(height: 30),

                  // Capture progress widget
                  Center(
                    child: CaptureProgressWidget(
                      onHistoryUpdated: () {
                        setState(() {});
                      },
                    ).animate().fadeIn(delay: 500.ms),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.to(PhotoTakeInstruction());
                      },
                      child: Text(
                        'home_screen.guide_button'.tr,
                        style: GoogleFonts.montserrat(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.green[700]!,
                          decorationThickness: 2,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // App logo
                  Center(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hamburger Menu Overlay
          if (_isMenuOpen)
            Positioned(
              top: 60,
              left: 10,
              child:
                  HamburgerMenu(
                    onClose: () {
                      setState(() {
                        _isMenuOpen = false;
                      });
                    },
                  ).animate().fadeIn(),
            ),
        ],
      ),
    );
  }
}
