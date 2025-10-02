// lib/models/train_model.dart

class Train {
  final String trainNumber;
  final String trainName;
  final String departureTime;
  final String arrivalTime;
  final String fromStation;
  final String toStation;
  final String travel_time; // --- THE MISSING PIECE ---

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.departureTime,
    required this.arrivalTime,
    required this.fromStation,
    required this.toStation,
    required this.travel_time, // --- ADDED HERE ---
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    // We can directly access the fields from the top-level data object now
    final trainData = json; 

    return Train(
      trainNumber: trainData['train_number'] ?? 'N/A',
      trainName: trainData['train_name'] ?? 'Unknown Train',
      departureTime: trainData['from_std'] ?? 'N/A', // Using from_std from JSON
      arrivalTime: trainData['to_std'] ?? 'N/A',   // Using to_std from JSON
      fromStation: 'N/A', // JSON does not provide full station names, we'll handle this later
      toStation: 'N/A',   // JSON does not provide full station names, we'll handle this later
      travel_time: trainData['travel_time'] ?? 'N/A', // --- AND ADDED HERE ---
    );
  }
}