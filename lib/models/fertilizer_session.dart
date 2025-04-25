class FertilizerSession {
  final DateTime date;
  final String averageResult;
  final List<String> individualResults;
  final String? recommendation;

  FertilizerSession({
    required this.date,
    required this.averageResult,
    required this.individualResults,
    this.recommendation,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'averageResult': averageResult,
      'individualResults': individualResults,
      'recommendation': recommendation, // Include in serialization
    };
  }

  factory FertilizerSession.fromMap(Map<String, dynamic> map) {
    return FertilizerSession(
      date: DateTime.parse(map['date']),
      averageResult: map['averageResult'] as String,
      individualResults: List<String>.from(map['individualResults'] as List),
      recommendation:
          map['recommendation'] as String?, // Include in deserialization
    );
  }

  @override
  String toString() {
    return 'FertilizerSession{date: $date, averageResult: $averageResult, individualResults: $individualResults}';
  }

  // Optional: Add equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FertilizerSession &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          averageResult == other.averageResult &&
          individualResults.equals(other.individualResults);

  @override
  int get hashCode =>
      date.hashCode ^ averageResult.hashCode ^ individualResults.hashCode;
}

// Extension for easy list comparison
extension ListEquals<T> on List<T> {
  bool equals(List<T> other) {
    if (length != other.length) return false;
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}
