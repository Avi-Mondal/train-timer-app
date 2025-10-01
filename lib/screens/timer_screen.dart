import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // This gives us a back button automatically
        title: const Text('Timer'),
      ),
      body: const Center(
        child: Text(
          'Timer Screen - Coming Soon!',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}