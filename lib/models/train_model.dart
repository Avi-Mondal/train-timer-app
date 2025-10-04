import 'package:intl/intl.dart';

class Train {
  final String trainNumber;
  final String trainName;
  final String departureTimeRaw;
  final String arrivalTimeRaw;
  final String fromStation;
  final String toStation;
  final String travelTimeRaw;

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.departureTimeRaw,
    required this.arrivalTimeRaw,
    required this.fromStation,
    required this.toStation,
    required this.travelTimeRaw,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainNumber: json['train_number'] ?? 'N/A',
      trainName: json['train_name'] ?? 'Unknown Train',
      departureTimeRaw: json['from_std'] ?? 'N/A',
      arrivalTimeRaw: json['to_sta'] ?? 'N/A',
      fromStation: json['train_src'] ?? 'N/A',
      toStation: json['train_dstn'] ?? 'N/A',
      travelTimeRaw: json['travel_time'] ?? 'N/A',
    );
  }

  // --- MODIFIED: A more robust getter ---
  DateTime get departureDateTime {
    // First, check if the data is valid before trying to parse it.
    if (departureTimeRaw == 'N/A') {
      return DateTime.now(); // Return a default value if data is missing
    }

    final now = DateTime.now();
    try {
      final parts = departureTimeRaw.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      DateTime departure = DateTime(now.year, now.month, now.day, hour, minute);

      if (departure.isBefore(now)) {
        departure = departure.add(const Duration(days: 1));
      }
      return departure;
    } catch (e) {
      print('Error parsing departure time: $e');
      return now;
    }
  }

  // --- MODIFIED: A more robust getter ---
  DateTime get arrivalDateTime {
    // First, check if the data is valid before trying to parse it.
    if (arrivalTimeRaw == 'N/A') {
      return DateTime.now();
    }

    final now = DateTime.now();
    try {
      final parts = arrivalTimeRaw.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      DateTime arrival = DateTime(now.year, now.month, now.day, hour, minute);

      if (arrival.isBefore(departureDateTime)) {
        arrival = arrival.add(const Duration(days: 1));
      }
      return arrival;
    } catch (e) {
      print('Error parsing arrival time: $e');
      return now;
    }
  }

  String get formattedDepartureTime {
    return DateFormat('HH:mm').format(departureDateTime);
  }

  String get formattedArrivalTime {
    return DateFormat('HH:mm').format(arrivalDateTime);
  }
}