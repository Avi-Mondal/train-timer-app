import 'package:flutter/material.dart';
import 'package:train_timer_app/models/train_model.dart'; // Import the Train model

class TimerScreen extends StatelessWidget {
  // --- NEW: Add a final variable to hold the train data ---
  final Train train;

  // --- MODIFIED: The constructor now requires a Train object ---
  const TimerScreen({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // --- MODIFIED: Display the name of the train we received ---
        title: Text(train.trainName),
      ),
      body: Center(
        child: Text(
          'Details for ${train.trainName} will be shown here.',
          style: const TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}