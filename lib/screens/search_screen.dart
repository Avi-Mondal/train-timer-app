import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Haptic Feedback

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // A variable to track if the button is being pressed down.
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // We get the scale factor based on the pressed state
    final scale = _isPressed ? 0.98 : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Trains'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Your TextFields are unchanged for now
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter From Station',
              ),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter To Station',
              ),
            ),
            const SizedBox(height: 24.0),

            // --- OUR NEW "PRO" BUTTON ---
            GestureDetector(
              onTapDown: (_) {
    HapticFeedback.lightImpact();
    setState(() {
      _isPressed = true;
    });
  },
  onTapUp: (_) => setState(() {
    _isPressed = false;
    // We will add the search functionality here later
  }),
  onTapCancel: () => setState(() {
    _isPressed = false;
  }),
  child: AnimatedScale(
    scale: scale,
    duration: const Duration(milliseconds: 150),
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // THIS IS THE KEY CHANGE
        // We now get the color directly from the app's theme.
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Search Trains',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // And we get the text color from the theme too.
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}