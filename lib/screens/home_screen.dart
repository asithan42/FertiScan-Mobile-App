import 'package:fertiscanapp/util/capture_progress.dart';
import 'package:fertiscanapp/util/greeting_widget.dart';
import 'package:fertiscanapp/widgets/hamburger_menu.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App bar with hamburger menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _isMenuOpen = true;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Greeting box
                  const GreetingWidget(),

                  const SizedBox(height: 30),

                  // Instruction Text
                  Center(
                    child: Text(
                      'check 05 randomly selected rice plants per field to get\nfertilizer recommendation',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sample image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/farmer_home_page.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Capture progress widget
                  Center(
                    child: CaptureProgressWidget(
                      onHistoryUpdated: () {
                        // This will force the hamburger menu to reload history when shown
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hamburger Menu overlay
          if (_isMenuOpen)
            Positioned(
              top: 60,
              left: 10,
              child: HamburgerMenu(
                onClose: () {
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
