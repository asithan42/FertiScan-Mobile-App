// import 'package:fertiscanapp/constant/colors.dart';
// import 'package:fertiscanapp/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class RecommendationScreen extends StatelessWidget {
//   final String averageResult;
//   final List<String> individualResults;

//   const RecommendationScreen({
//     super.key,
//     required this.averageResult,
//     required this.individualResults,
//   });

//   // Helper method to get recommendation details
//   Map<String, String> _getRecommendationDetails(String swapValue) {
//     switch (swapValue.toLowerCase()) {
//       case 'swap1':
//         return {
//           'title': 'SWAP 1 - Very Deficient',
//           'color': 'Yellow',
//           'lcc': '2',
//           'urea': '50-60 kg/ha',
//           'action': 'Apply immediately',
//           'colorCode': '0xFF68BA0F', // Red
//         };
//       case 'swap2':
//         return {
//           'title': 'SWAP 2 - Deficient',
//           'color': 'Yellow-Green',
//           'lcc': '3',
//           'urea': '40-50 kg/ha',
//           'action': 'Apply soon',
//           'colorCode': '0xFF19CF1F', // Yellow
//         };
//       case 'swap3':
//         return {
//           'title': 'SWAP 3 - Adequate',
//           'color': 'Green',
//           'lcc': '4',
//           'urea': '30-40 kg/ha',
//           'action': 'Apply if needed',
//           'colorCode': '0xFF4CAF50', // Green
//         };
//       case 'swap4':
//         return {
//           'title': 'SWAP 4 - Sufficient/Excess',
//           'color': 'Dark Green',
//           'lcc': '5',
//           'urea': '0 kg/ha',
//           'action': 'Skip urea application',
//           'colorCode': '0xFF006400', // Dark Green
//         };
//       default:
//         return {
//           'title': 'Unknown Result',
//           'color': '',
//           'lcc': '',
//           'urea': '',
//           'action': 'Consult an expert',
//           'colorCode': '0xFF000000', // Black
//         };
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final recommendation = _getRecommendationDetails(averageResult);
//     final color = Color(int.parse(recommendation['colorCode']!));

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Fertilizer Recommendation',
//           style: GoogleFonts.montserrat(
//             color: kGreenColor1,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 30),
//           Image.asset(
//             'assets/images/fertilizer_reccomendation .png', // Add this image to your assets
//             height: 250,
//           ),
//           const SizedBox(height: 10),
//           // Result Summary Card
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               color: kGreyColor1,

//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Final Recommendation',
//                       style: GoogleFonts.montserrat(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Container(
//                           width: 20,
//                           height: 20,
//                           decoration: BoxDecoration(
//                             color: color,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           recommendation['title']!,
//                           style: GoogleFonts.montserrat(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     _buildDetailRow('Leaf Color', recommendation['color']!),
//                     _buildDetailRow('LCC Value', recommendation['lcc']!),
//                     _buildDetailRow(
//                       'Urea Recommendation',
//                       recommendation['urea']!,
//                     ),
//                     _buildDetailRow('Action', recommendation['action']!),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
// ElevatedButton(
//   onPressed: () {
//     Get.offAll(() => const HomeScreen());
//   },
//   style: ElevatedButton.styleFrom(
//     backgroundColor: kGreenColor1,
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(15),
//     ),
//   ),
//   child: Text(
//     'Go to Home',
//     style: GoogleFonts.montserrat(
//       fontSize: 16,
//       fontWeight: FontWeight.w600,
//       color: Colors.white,
//     ),
//   ),
// ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
                        Navigator.of(context).pop();
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
                      _infoRow("recommendation_screen.urea_label".tr, rec['urea'], Icons.shopping_bag),
                      const SizedBox(height: 8),
                      _infoRow("recommendation_screen.action_label".tr, rec['action'], Icons.task_alt),
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
