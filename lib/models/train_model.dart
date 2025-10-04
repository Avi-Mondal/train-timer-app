// lib/models/train_model.dart

import 'package:intl/intl.dart'; // We'll need this for date/time formatting

class Train {
  final String trainNumber;
  final String trainName;
  final String departureTimeRaw; // Raw string from JSON (e.g., "16:50")
  final String arrivalTimeRaw;   // Raw string from JSON (e.g., "10:50")
  final String fromStation;
  final String toStation;
  final String travelTimeRaw; // Raw string for total travel (e.g., "18:00")

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.departureTimeRaw,
    required this.arrivalTimeRaw,
    required this.fromStation,
    required this.toStation,
    required this.travelTimeRaw,
  });



// Replace your old factory constructor with this one
factory Train.fromJson(Map<String, dynamic> json) {
  return Train(
    trainNumber: json['train_number'] ?? 'N/A',
    trainName: json['train_name'] ?? 'Unknown Train',
    departureTimeRaw: json['from_std'] ?? 'N/A', // Use from_std for departure time
    arrivalTimeRaw: json['to_sta'] ?? 'N/A',   // Use to_sta for arrival time
    fromStation: json['from_station_name'] ?? 'N/A', // Use the full station name
    toStation: json['to_station_name'] ?? 'N/A',   // Use the full station name
    travelTimeRaw: json['duration'] ?? 'N/A',      // Use duration for travel time
  );
}

  // --- NEW: Helper method to get departure time as DateTime ---
  DateTime get departureDateTime {
    // We need a dummy date to combine with the time.
    // Assuming trains depart/arrive on the current day or the next.
    final now = DateTime.now();
    try {
      final parts = departureTimeRaw.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      DateTime departure = DateTime(now.year, now.month, now.day, hour, minute);

      // If departure time is in the past, assume it's for tomorrow
      if (departure.isBefore(now)) {
        departure = departure.add(const Duration(days: 1));
      }
      return departure;
    } catch (e) {
      print('Error parsing departure time: $e');
      return now; // Fallback to current time if parsing fails
    }
  }

  // --- NEW: Helper method to get arrival time as DateTime ---
  DateTime get arrivalDateTime {
    final now = DateTime.now();
    try {
      final parts = arrivalTimeRaw.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      DateTime arrival = DateTime(now.year, now.month, now.day, hour, minute);

      // If arrival time is before departure, it must be the next day
      if (arrival.isBefore(departureDateTime)) {
        arrival = arrival.add(const Duration(days: 1));
      }
      return arrival;
    } catch (e) {
      print('Error parsing arrival time: $e');
      return now; // Fallback
    }
  }

  // --- NEW: Helper to get formatted departure time ---
  String get formattedDepartureTime {
    return DateFormat('HH:mm').format(departureDateTime);
  }

  // --- NEW: Helper to get formatted arrival time ---
  String get formattedArrivalTime {
    return DateFormat('HH:mm').format(arrivalDateTime);
  }
}