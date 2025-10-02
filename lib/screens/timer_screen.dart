import 'package:flutter/material.dart';
import 'package:train_timer_app/models/train_model.dart';
import 'dart:async'; 

// We convert this to a StatefulWidget to prepare for the live timer later.
class TimerScreen extends StatefulWidget {
  final Train train;
  const TimerScreen({super.key, required this.train});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // --- NEW: State variables to manage the timer ---
  Timer? _timer;
  Duration _remainingTime = Duration.zero;

  // --- NEW: A helper function to format Duration into MM:SS ---
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // --- NEW: This method runs once when the screen is created ---
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // --- NEW: This method cleans up the timer when the screen is destroyed ---
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // --- NEW: The core logic for our countdown ---
  void _startTimer() {
    // Calculate the initial remaining time
    _remainingTime = widget.train.arrivalDateTime.difference(DateTime.now());

    // Create a timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // On each tick, decrement the duration by one second
        final seconds = _remainingTime.inSeconds - 1;
        if (seconds < 0) {
          // If the timer is finished, cancel it
          _timer?.cancel();
          // Optionally, you can set the text to "Arrived"
          _remainingTime = Duration.zero;
        } else {
          _remainingTime = Duration(seconds: seconds);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.train.trainName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Arriving In',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    // --- MODIFIED: This now displays our dynamic time ---
                    Text(
                      _formatDuration(_remainingTime),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Platform 4', // Placeholder
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}