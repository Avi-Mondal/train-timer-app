import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_timer_app/models/train_model.dart';
import 'package:train_timer_app/widgets/timer_painter.dart';

// --- THIS IS THE "BLUEPRINT" PART THAT WAS MISSING ---
class TimerScreen extends StatefulWidget {
  final Train train;
  const TimerScreen({super.key, required this.train});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

// --- THIS IS THE "WORKING MACHINE" PART YOU ALREADY HAVE ---
class _TimerScreenState extends State<TimerScreen> {
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
    final targetTime = widget.train.arrivalDateTime;
    _totalTime = targetTime.difference(DateTime.now());

    if (_totalTime.inSeconds <= 0) {
      setState(() {
        _progress = 1.0;
        _remainingTime = Duration.zero;
        _arcColor = Colors.green;
      });
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = targetTime.difference(DateTime.now());

        if (_remainingTime.inSeconds < 0) {
          _timer?.cancel();
          _remainingTime = Duration.zero;
          _progress = 1.0;
          _arcColor = Colors.green;
        } else {
          _progress = 1.0 - (_remainingTime.inSeconds / _totalTime.inSeconds);
          
          if (_remainingTime.inMinutes < 1) {
            _arcColor = Colors.red;
          } else if (_remainingTime.inMinutes < 5) {
            _arcColor = Colors.orange;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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