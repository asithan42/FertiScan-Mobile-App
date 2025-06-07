import 'package:fertiscanapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationScreen extends StatelessWidget {
  final String averageResult;
  final List<String> individualResults;

  const RecommendationScreen({
    super.key,
    required this.averageResult,
    required this.individualResults,
  });

  Map<String, dynamic> _getRecommendationDetails(String swapValue) {
    final key = 'recommendation_screen.${swapValue.toLowerCase()}';
    return {
      'desc': '$key.desc'.tr,
      'color': _getColor(swapValue),
      'urea': '$key.urea'.tr,
      'action': '$key.action'.tr,
      'emoji': _getEmoji(swapValue),
      'bgColor': _getBgColor(swapValue),
    };
  }

  Color? _getColor(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return Colors.yellow[700];
      case 'swap2':
        return Colors.lightGreen;
      case 'swap3':
        return Colors.green[400];
      case 'swap4':
        return Colors.green[900];
      default:
        return Colors.grey;
    }
  }

  Color? _getBgColor(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return Colors.yellow[100];
      case 'swap2':
        return Colors.lightGreen[100];
      case 'swap3':
        return Colors.green[100];
      case 'swap4':
        return Colors.green[50];
      default:
        return Colors.grey[200];
    }
  }

  String _getEmoji(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return '🚨';
      case 'swap2':
        return '⚠️';
      case 'swap3':
        return '🌿';
      case 'swap4':
        return '💚';
      default:
        return '🧑‍🌾';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rec = _getRecommendationDetails(averageResult);

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  rec['color'].withOpacity(0.3),
                  rec['bgColor'],
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: rec['color']),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "recommendation_screen.title".tr,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: rec['color'],
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3),
                ),

                const SizedBox(height: 20),
                // Image
                Image.asset(
                  'assets/images/fertilizer_reccomendation .png',
                  height: 200,
                ).animate().fadeIn(duration: 800.ms),

                const SizedBox(height: 20),
                // Recommendation Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${rec['emoji']} ${rec['desc']}",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: rec['color'],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _infoRow(
                        "recommendation_screen.urea_label".tr,
                        rec['urea'],
                        Icons.shopping_bag,
                      ),
                      const SizedBox(height: 8),
                      _infoRow(
                        "recommendation_screen.action_label".tr,
                        rec['action'],
                        Icons.task_alt,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 700.ms).slideY(),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => const HomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rec['color'],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'recommendation_screen.go_home_button'.tr,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ).animate().fadeIn(delay: NumDurationExtensions(1).seconds),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
