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
            const Text('Level 1'), // Placeholder
            const Text('Level 2'), // Placeholder
            const Text('Level 3'), // Placeholder
            // TODO: Implement actual level selection logic
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen (Main Menu)
              },
              child: const Text('Back to Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
