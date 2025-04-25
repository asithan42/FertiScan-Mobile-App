import 'package:fertiscanapp/models/fertilizer_session.dart';
import 'package:fertiscanapp/screens/Scan_Lcc_Chart_Screen.dart';
import 'package:fertiscanapp/screens/reccomendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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

              if (_photosTaken == 5) {
                _processCompleteSession();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          child: Text(
            _photosTaken == 0
                ? 'Start Capture'
                : 'Capture Next ($_photosTaken/5)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
        recommendation: recommendation['title'],
      ).toMap(),
      ...sessions,
    ];

    _storage.write('fertilizerSessions', updatedSessions);
    widget.onHistoryUpdated(); // Notify parent to refresh

    Get.offAll(
      () => RecommendationScreen(
        averageResult: average,
        individualResults: _sessionResults,
      ),
    );

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

  Map<String, String> _getRecommendationDetails(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return {'title': 'SWAP 1 - Very Deficient (50-60 kg/ha urea)'};
      case 'swap2':
        return {'title': 'SWAP 2 - Deficient (40-50 kg/ha urea)'};
      case 'swap3':
        return {'title': 'SWAP 3 - Adequate (No urea needed)'};
      case 'swap4':
        return {'title': 'SWAP 4 - Sufficient/Excess (Skip urea)'};
      default:
        return {'title': 'Unknown Result'};
    }
  }
}
