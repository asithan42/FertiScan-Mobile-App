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
  List<FertilizerSession> _sessions = [];
  final List<int> _selectedIndices = [];
  bool _isSelecting = false;
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final storedSessions = _storage.read<List>('fertilizerSessions') ?? [];
    setState(() {
      _sessions = storedSessions
          .map(
            (e) => FertilizerSession.fromMap(Map<String, dynamic>.from(e)),
          )
          .toList();
    });
  }

  String _getUreaRecommendation(String swapValue) {
    switch (swapValue.toLowerCase()) {
      case 'swap1':
        return 'history_screen.swap1'.tr;
      case 'swap2':
        return 'history_screen.swap2'.tr;
      case 'swap3':
        return 'history_screen.swap3'.tr;
      case 'swap4':
        return 'history_screen.swap4'.tr;
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

  Future<void> _deleteSessions(List<int> indices) async {
    indices.sort((a, b) => b.compareTo(a));
    final updatedSessions = List<FertilizerSession>.from(_sessions);

    for (final index in indices) {
      if (index >= 0 && index < updatedSessions.length) {
        updatedSessions.removeAt(index);
      }
    }

    await _storage.write(
      'fertilizerSessions',
      updatedSessions.map((e) => e.toMap()).toList(),
    );
    await _loadSessions();
  }

  void _deleteSelected() async {
    final shouldDelete = await Get.dialog<bool>(
          AlertDialog(
            title: Text('history_screen.delete_selected_title'.tr),
            content: Text(
              'history_screen.delete_selected_content'
                  .trParams({'count': _selectedIndices.length.toString()}),
              style: GoogleFonts.montserrat(),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('common.cancel'.tr),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'common.delete'.tr,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      await _deleteSessions(_selectedIndices);
      setState(() {
        _selectedIndices.clear();
        _isSelecting = false;
      });
    }
  }

  void _deleteSingleItem(int index) async {
    final shouldDelete = await Get.dialog<bool>(
          AlertDialog(
            title: Text('history_screen.delete_single_title'.tr),
            content: Text(
              'history_screen.delete_single_content'.tr,
              style: GoogleFonts.montserrat(),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('common.cancel'.tr),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'common.delete'.tr,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldDelete) {
      await _deleteSessions([index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSelecting
            ? Text(
                'history_screen.selected_count'
                    .trParams({'count': _selectedIndices.length.toString()}),
                style: GoogleFonts.montserrat(
                  color: kGreenColor1,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                'history_screen.title'.tr,
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
              tooltip: 'history_screen.tooltip_delete_selected'.tr,
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
              tooltip: 'history_screen.tooltip_cancel_selection'.tr,
            ),
        ],
      ),
      body: _sessions.isEmpty
          ? Center(
              child: Text(
                'history_screen.no_history'.tr,
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
                  key: Key(session.date.toIso8601String()),
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
                        Get.to(
                          () => RecommendationScreen(
                            averageResult: session.averageResult,
                            individualResults: session.individualResults,
                          ),
                        );
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
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          'history_screen.urea_needed'.trParams({'urea': urea}),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          date,
                          style: GoogleFonts.montserrat(color: kGreyColor2),
                        ),
                        trailing:
                            _isSelecting ? null : const Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
