import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
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

  // Helper method to get recommendation details
  Map<String, String> _getRecommendationDetails(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return {
          'title': 'SWAP 1 - Very Deficient',
          'color': 'Yellow',
          'lcc': '2',
          'urea': '50-60 kg/ha',
          'action': 'Apply immediately',
          'colorCode': '0xFF68BA0F', // Red
        };
      case 'swap2':
        return {
          'title': 'SWAP 2 - Deficient',
          'color': 'Yellow-Green',
          'lcc': '3',
          'urea': '40-50 kg/ha',
          'action': 'Apply soon',
          'colorCode': '0xFF19CF1F', // Yellow
        };
      case 'swap3':
        return {
          'title': 'SWAP 3 - Adequate',
          'color': 'Green',
          'lcc': '4',
          'urea': '0 kg/ha',
          'action': 'No need to apply urea',
          'colorCode': '0xFF4CAF50', // Green
        };
      case 'swap4':
        return {
          'title': 'SWAP 4 - Sufficient/Excess',
          'color': 'Dark Green',
          'lcc': '5',
          'urea': '0 kg/ha',
          'action': 'Skip urea application',
          'colorCode': '0xFF006400', // Dark Green
        };
      default:
        return {
          'title': 'Unknown Result',
          'color': '',
          'lcc': '',
          'urea': '',
          'action': 'Consult an expert',
          'colorCode': '0xFF000000', // Black
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = _getRecommendationDetails(averageResult);
    final color = Color(int.parse(recommendation['colorCode']!));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Fertilizer Recommendation',
          style: GoogleFonts.montserrat(
            color: kGreenColor1,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Image.asset(
            'assets/images/fertilizer_reccomendation .png', // Add this image to your assets
            height: 250,
          ),
          const SizedBox(height: 10),
          // Result Summary Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: kGreyColor1,

              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Final Recommendation',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          recommendation['title']!,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildDetailRow('Leaf Color', recommendation['color']!),
                    _buildDetailRow('LCC Value', recommendation['lcc']!),
                    _buildDetailRow(
                      'Urea Recommendation',
                      recommendation['urea']!,
                    ),
                    _buildDetailRow('Action', recommendation['action']!),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.offAll(() => const HomeScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreenColor1,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Go to Home',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
