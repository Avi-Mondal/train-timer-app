import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // We need this for rootBundle
import 'package:train_timer_app/models/train_model.dart'; // Import your new Train model
import 'package:train_timer_app/screens/timer_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  bool _isLoading = false;
  // --- MODIFIED: Our list now holds clean Train objects! ---
  List<Train> _searchResults = [];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  // --- MODIFIED: This function now reads from your local file ---
  void _performSearch() async {
    // We still use the controllers, but won't need them until we use a real API
    final fromStation = _fromController.text;
    final toStation = _toController.text;
    print('Searching for trains from: $fromStation to: $toStation');

    setState(() {
      _searchResults.clear();
      _isLoading = true;
    });

    try {
      // 1. Load the JSON file from assets as a string
      final String response = await rootBundle.loadString('assets/sample_response.json');

      // 2. Decode the JSON string into a Map
      final data = jsonDecode(response);

      // 3. Get the list of trains from inside the data
      final List<dynamic> trainList = data['data'];

      // 4. Convert the raw list into a list of clean Train objects
      setState(() {
        _searchResults = trainList.map((json) => Train.fromJson(json)).toList();
      });

    } catch (e) {
      print('An error occurred: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Trains'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(hintText: 'Enter From Station'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(hintText: 'Enter To Station'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Search Trains'),
            ),
            const SizedBox(height: 24.0),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                // --- MODIFIED: The ListView now displays Train objects ---
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    // 'train' is now a clean Train object
                    final train = _searchResults[index];

                    return Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        // We use train.trainName, which is safe and clear
                        title: Text(train.trainName),
                        // The new, more informative subtitle
                        subtitle: Text(
                          'Departs: ${train.formattedDepartureTime}   Arrives: ${train.formattedArrivalTime}\n'
                          'Train No: ${train.trainNumber}',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimerScreen(train: train)),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}