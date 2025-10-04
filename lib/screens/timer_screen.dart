import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_timer_app/models/train_model.dart';
import 'package:train_timer_app/widgets/timer_painter.dart';

// --- NEW: Step 1 ---
// Define the possible states for our screen.
enum TimerStatus { counting, finished }

class TimerScreen extends StatefulWidget {
  final Train train;
  const TimerScreen({super.key, required this.train});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // --- NEW: Step 2 ---
  // A state variable to remember our current status.
  TimerStatus _status = TimerStatus.counting;

  Timer? _timer;
  Duration _totalTime = Duration.zero;
  Duration _remainingTime = Duration.zero;
  double _progress = 0.0;
  late Color _arcColor;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "$hours:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arcColor = Theme.of(context).colorScheme.primary;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
  // --- TEMPORARY TEST CODE: We force a 30-second countdown ---
  _totalTime = const Duration(seconds: 30);
  _remainingTime = const Duration(seconds: 30);
  // --- END OF TEMPORARY TEST CODE ---

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      // For this test, we use the simple "subtract 1 second" logic
      final seconds = _remainingTime.inSeconds - 1;

      if (seconds < 0) {
        _timer?.cancel();
        _status = TimerStatus.finished;
      } else {
        _remainingTime = Duration(seconds: seconds);
        _progress = 1.0 - (_remainingTime.inSeconds / _totalTime.inSeconds);
        
        // Use thresholds that work for a 30-second test
        if (_remainingTime.inSeconds <= 10) {
          _arcColor = Colors.red;
        } else if (_remainingTime.inSeconds <= 20) {
          _arcColor = Colors.orange;
        }
      }
    });
  });
}
  // A helper function to build our timer view
  // Replace your empty _buildTimerView with this one

Widget _buildTimerView() {
  final theme = Theme.of(context); // We need the theme data here
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          // The Painter for the circle and arc
          SizedBox(
            width: 250,
            height: 250,
            child: CustomPaint(
              painter: TimerPainter(
                progress: _progress,
                progressColor: _arcColor,
                backgroundColor: Colors.grey.shade800,
              ),
            ),
          ),
          // The Column for the text on top
          Column(
            mainAxisSize: MainAxisSize.min, // Important for centering
            children: [
              const Text(
                'Departing In',
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
  );
}

  // A helper function to build our "finished" view
  Widget _buildFinishedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 150),
        const SizedBox(height: 24),
        const Text(
          'Train Departed!',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          'Happy Journey!',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            // This will close the timer screen and go back
            Navigator.of(context).pop();
          },
          child: const Text('Track Another Train'),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.train.trainName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // --- MODIFIED: Step 4 ---
      // The body now shows a different UI based on the _status
      body: Center(
        child: _status == TimerStatus.counting
            ? _buildTimerView() // If we are counting, show the timer
            : _buildFinishedView(), // Otherwise, show the finished screen
      ),
    );
  }
}