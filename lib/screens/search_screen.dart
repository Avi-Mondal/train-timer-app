import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // We need this for the date format
import 'package:train_timer_app/models/train_model.dart';
import 'package:train_timer_app/screens/timer_screen.dart';


// The "Blueprint" part
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// The "Working Machine" part
class _SearchScreenState extends State<SearchScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  bool _isLoading = false;
  List<Train> _searchResults = [];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  // --- THIS IS THE FINAL VERSION OF THE API CALL FUNCTION ---
  void _performSearch() async {
    FocusScope.of(context).unfocus();
    
    final fromStation = _fromController.text;
    final toStation = _toController.text;

    if (fromStation.isEmpty || toStation.isEmpty) {
      print("Error: Station codes cannot be empty.");
      return;
    }

    setState(() {
      _searchResults.clear();
      _isLoading = true;
    });

    try {
      final uri = Uri.https(
        'irctc1.p.rapidapi.com', // The correct Host
        '/api/v3/trainBetweenStations', // The correct Path
        { // The Query Parameters
          'fromStationCode': fromStation,
          'toStationCode': toStation,
          'dateOfJourney': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        },
      );

      final headers = {
        'X-RapidAPI-Key': 'e8e6ec17ddmsh8813fae0a7cb1f4p1e4b4bjsn5aa25cbdc42d',
        'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
      };

      final response = await http.get(uri, headers: headers);

      // Print everything to the console for debugging
      print('--- API RESPONSE ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('--------------------');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Assuming the list is inside a key called 'data'
        final List<dynamic> trainList = data['data'];

        setState(() {
          _searchResults = trainList.map((json) => Train.fromJson(json)).toList();
        });
      } else {
        print('API call failed!');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The build method is unchanged
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
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final train = _searchResults[index];
                    return Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: ListTile(
                        title: Text(train.trainName),
                        subtitle: Text('Train No: ${train.trainNumber} | Travel Time: ${train.travelTimeRaw}'),
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