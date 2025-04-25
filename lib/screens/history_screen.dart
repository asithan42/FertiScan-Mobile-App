import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/models/fertilizer_session.dart';
import 'package:fertiscanapp/screens/reccomendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<FertilizerSession> _sessions;
  final List<int> _selectedIndices = [];
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _loadSessionsFromStorage();
  }

  void _loadSessionsFromStorage() {
    final box = GetStorage();
    final storedSessions = box.read<List>('fertilizerSessions') ?? [];
    _sessions = storedSessions
        .map((e) => FertilizerSession.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    setState(() {}); // refresh UI
  }

  String _getUreaRecommendation(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return 'Apply 50-60 kg/ha';
      case 'swap2':
        return 'Apply 40-50 kg/ha';
      case 'swap3':
        return 'No need to apply. 0 kg/ha';
      case 'swap4':
        return 'No need to apply. 0 kg/ha';
      default:
        return 'N/A';
    }
  }

  Color _getSwapColor(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return const Color(0xFF68BA0F);
      case 'swap2':
        return const Color(0xFF19CF1F);
      case 'swap3':
        return const Color(0xFF4CAF50);
      case 'swap4':
        return const Color(0xFF006400);
      default:
        return Colors.grey;
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) _isSelecting = false;
      } else {
        _selectedIndices.add(index);
        _isSelecting = true;
      }
    });
  }

  void _deleteSelected() async {
    final shouldDelete = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Delete Recommendations'),
            content: Text(
              'Delete ${_selectedIndices.length} selected recommendation(s)?',
              style: GoogleFonts.montserrat(),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      setState(() {
        _selectedIndices.sort((a, b) => b.compareTo(a));
        for (final index in _selectedIndices) {
          _sessions.removeAt(index);
        }
        _selectedIndices.clear();
        _isSelecting = false;

        final box = GetStorage();
        box.write(
          'fertilizerSessions',
          _sessions.map((e) => e.toMap()).toList(),
        );
      });
    }
  }

  void _deleteSingleItem(int index) async {
    final shouldDelete = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Delete Recommendation'),
            content: Text(
              'Delete this recommendation?',
              style: GoogleFonts.montserrat(),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      setState(() {
        _sessions.removeAt(index);
        final box = GetStorage();
        box.write(
          'fertilizerSessions',
          _sessions.map((e) => e.toMap()).toList(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSelecting
            ? Text(
                '${_selectedIndices.length} Selected',
                style: GoogleFonts.montserrat(
                  color: kGreenColor1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                'Recommendation History',
                style: GoogleFonts.montserrat(
                  color: kGreenColor1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: [
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelected,
              tooltip: 'Delete Selected',
            ),
          if (_isSelecting)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedIndices.clear();
                  _isSelecting = false;
                });
              },
              tooltip: 'Cancel Selection',
            ),
        ],
      ),
      body: _sessions.isEmpty
          ? Center(
              child: Text(
                'No history available',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: kGreyColor2,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                final urea = _getUreaRecommendation(session.averageResult);
                final date = DateFormat('MMM dd, yyyy - hh:mm a')
                    .format(session.date);
                final color = _getSwapColor(session.averageResult);
                final isSelected = _selectedIndices.contains(index);

                return Dismissible(
                  key: Key(session.date.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    if (!_isSelecting) {
                      _deleteSingleItem(index);
                      return false;
                    }
                    return false;
                  },
                  child: InkWell(
                    onLongPress: () => _toggleSelection(index),
                    onTap: () {
                      if (_isSelecting) {
                        _toggleSelection(index);
                      } else {
                        Get.to(() => RecommendationScreen(
                              averageResult: session.averageResult,
                              individualResults: session.individualResults,
                            ));
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      color: isSelected ? Colors.grey[200] : null,
                      child: ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        title: Text(
                          'Needed Urea amount: $urea',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          date,
                          style: GoogleFonts.montserrat(color: kGreyColor2),
                        ),
                        trailing: _isSelecting
                            ? null
                            : const Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
