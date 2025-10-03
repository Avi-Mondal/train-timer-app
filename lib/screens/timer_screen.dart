import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_timer_app/models/train_model.dart';
import 'package:train_timer_app/widgets/timer_painter.dart'; // Import our new painter

class TimerScreen extends StatefulWidget {
  final Train train;
  const TimerScreen({super.key, required this.train});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  Duration _totalTime = Duration.zero;
  Duration _remainingTime = Duration.zero;
  double _progress = 0.0;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
  // Store the final arrival time once. This is our fixed target.
  final targetTime = widget.train.arrivalDateTime;

  // Calculate the initial total duration for our progress calculation
  _totalTime = targetTime.difference(DateTime.now());
  
  // Handle cases where the train has already arrived or data is invalid
  if (_totalTime.inSeconds <= 0) {
    setState(() {
      _progress = 1.0; // Set progress to full
      _remainingTime = Duration.zero;
    });
    return; // Don't start the timer
  }

  // Create a timer that ticks every second
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      // On each tick, RE-CALCULATE the remaining time from the target.
      _remainingTime = targetTime.difference(DateTime.now());

      if (_remainingTime.inSeconds < 0) {
        _timer?.cancel();
        _remainingTime = Duration.zero;
        _progress = 1.0;
      } else {
        // The progress calculation will now work correctly with the real total time
        _progress = 1.0 - (_remainingTime.inSeconds / _totalTime.inSeconds);
      }
    });
  });
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //print('BUILD METHOD: Rebuilding with progress $_progress');
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
                // --- THIS IS THE BIG CHANGE ---
                // We use our CustomPaint widget here
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CustomPaint(
                    painter: TimerPainter(
                      progress: _progress,
                      progressColor: theme.colorScheme.primary, // Use our theme's accent color
                      backgroundColor: Colors.grey.shade800,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Arriving In',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
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
            Text(
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