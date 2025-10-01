import 'package:flutter/material.dart';
import 'package:train_timer_app/screens/timer_screen.dart';
// We don't need the services import here anymore if the button code is changing

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  // --- NEW: Step 1 ---
  // Create the controllers at the top of your state class.
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  // State variables to hold our data and loading status
  bool _isLoading = false;
  final List<String> _searchResults = [];

  // --- NEW: Step 4 ---
  // It's a best practice to dispose of controllers when the screen is destroyed
  // to free up memory.
  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _performSearch() async {
    // --- NEW: Step 3 ---
    // Access the text from the controllers.
    final fromStation = _fromController.text;
    final toStation = _toController.text;

    // A simple print statement to prove that we've captured the text.
    print('Searching for trains from: $fromStation to: $toStation');

    // 1. Clear previous results and show a loading indicator
    setState(() {
      _searchResults.clear();
      _isLoading = true;
    });

    // 2. Simulate a network delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // 3. Add some fake search results
    setState(() {
      _isLoading = false;
      _searchResults.addAll([
        '12345 - Sealdah Duronto',
        '54321 - Howrah Express',
        '98765 - Diamond Harbour Local',
      ]);
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
          children: [
            // --- NEW: Step 2 ---
            // Attach the controller to the TextField.
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                hintText: 'Enter From Station',
              ),
            ),
            const SizedBox(height: 16.0),
            // Attach the other controller to this TextField.
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                hintText: 'Enter To Station',
              ),
            ),
            const SizedBox(height: 24.0),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _performSearch,
                child: const Text('Search Trains'),
              ),
            ),
            const SizedBox(height: 24.0),
            
            // The rest of the file is the same...
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final train = _searchResults[index];
                    return Card(
                      child: ListTile(
                        title: Text(train),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TimerScreen()),
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