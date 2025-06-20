import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/models/fertilizer_session.dart';
import 'package:fertiscanapp/screens/reccomendation_screen.dart';
import 'package:fertiscanapp/screens/scan_rice_leaf_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class CaptureProgressWidget extends StatefulWidget {
  final VoidCallback onHistoryUpdated;

  const CaptureProgressWidget({super.key, required this.onHistoryUpdated});

  @override
  State<CaptureProgressWidget> createState() => _CaptureProgressWidgetState();
}

class _CaptureProgressWidgetState extends State<CaptureProgressWidget> {
  int _photosTaken = 0;
  final List<String> _sessionResults = [];
  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            final result = await Get.to(() => ScanRiceLeafScreen());
            if (result != null) {
              setState(() {
                _photosTaken++;
                _sessionResults.add(result);
              });

              if (_photosTaken == 10) {
                _processCompleteSession();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            backgroundColor: kGreenColor2,
          ),
          child: Text(
            _photosTaken == 0
                ? 'capture_widget.start_button'.tr
                : 'capture_widget.capture_next_button'
                    .trParams({'count': _photosTaken.toString()}),
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kWhiteColor,
            ),
          ),
        ),
      ],
    );
  }

  void _processCompleteSession() {
    final average = _calculateAverageResult(_sessionResults);
    final recommendation = _getRecommendationDetails(average);

    final sessions = _storage.read<List>('fertilizerSessions') ?? [];
    final updatedSessions = [
      FertilizerSession(
        date: DateTime.now(),
        averageResult: average,
        individualResults: List.from(_sessionResults),
        recommendation: recommendation,
      ).toMap(),
      ...sessions,
    ];

    _storage.write('fertilizerSessions', updatedSessions);
    widget.onHistoryUpdated();

    Get.off(() => RecommendationScreen(
          averageResult: average,
          individualResults: _sessionResults,
        ));

    setState(() {
      _photosTaken = 0;
      _sessionResults.clear();
    });
  }

  String _calculateAverageResult(List<String> results) {
    final counts = <String, int>{};
    for (final result in results) {
      counts[result] = (counts[result] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String _getRecommendationDetails(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return 'capture_widget.swap1'.tr;
      case 'swap2':
        return 'capture_widget.swap2'.tr;
      case 'swap3':
        return 'capture_widget.swap3'.tr;
      case 'swap4':
        return 'capture_widget.swap4'.tr;
      default:
        return 'capture_widget.unknown'.tr;
    }
  }
}
