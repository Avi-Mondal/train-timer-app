import 'dart:async';
import 'package:flutter/material.dart';
import 'package:train_timer_app/models/train_model.dart';
import 'package:train_timer_app/widgets/timer_painter.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

// --- NEW: Step 1 ---
// Define the possible states for our screen.
enum TimerStatus { counting, finished }

class TimerScreen extends StatefulWidget {
  final Train train;
  const TimerScreen({super.key, required this.train});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Timer? _timer;
  Duration _totalTime = Duration.zero;
  Duration _remainingTime = Duration.zero;
  double _progress = 0.0;
  late Color _arcColor;
  TimerStatus _status = TimerStatus.counting;

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    //_totalTime = const Duration(seconds: 45);
    //_remainingTime = _totalTime;
    final targetTime = widget.train.departureDateTime;
    _totalTime = targetTime.difference(DateTime.now());

    if (_totalTime.inSeconds <= 0) {
      setState(() {
        _status = TimerStatus.finished;
      });
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = targetTime.difference(DateTime.now());

        if (_remainingTime.inSeconds < 0) {
          _timer?.cancel();
          _status = TimerStatus.finished;
          _animationController.stop(); // Stop animation when timer finishes
        } else {
          _progress = 1.0 - (_remainingTime.inSeconds / _totalTime.inSeconds);
          
          Color newColor = Theme.of(context).colorScheme.primary;
          if (_remainingTime.inMinutes < 1) {
            newColor = Colors.red;
          } else if (_remainingTime.inMinutes < 5) {
            newColor = Colors.orange;
          }

          if (newColor != _arcColor) {
            HapticFeedback.mediumImpact();
            _arcColor = newColor;
          }

          if (_remainingTime.inSeconds <= 30) {
            if (!_animationController.isAnimating) {
              _animationController.repeat(reverse: true);
            }
          } else {
            if (_animationController.isAnimating) {
              _animationController.stop();
            }
          }
        }
      });
    });
  }

  Widget _buildFinishedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 150),
        const SizedBox(height: 24),
        const Text(
          'Train Departing!',
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
            Navigator.of(context).pop();
          },
          child: const Text('Track Another Train'),
        ),
      ],
    );
  }

  Widget _buildTimerView() {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- THIS IS THE FULLY CODED PART THAT WAS MISSING ---
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
                mainAxisSize: MainAxisSize.min,
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
        ),
        const SizedBox(height: 40),
        const Text(
          'Platform 4',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.train.trainName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: _status == TimerStatus.counting
            ? _buildTimerView()
            : _buildFinishedView(),
      ),
    );
  }
}