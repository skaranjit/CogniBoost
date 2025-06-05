import 'package:flutter/material.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Placeholder for level listing.'),
            // Example: A few level buttons
            ElevatedButton(
              child: const Text('Level 1'),
              onPressed: () {
                // Placeholder: Navigate to game with level 1
                Navigator.pushNamed(context, '/game');
              },
            ),
            ElevatedButton(
              child: const Text('Level 2'),
              onPressed: () {
                // Placeholder: Navigate to game with level 2
                Navigator.pushNamed(context, '/game');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Back to Main Menu'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
