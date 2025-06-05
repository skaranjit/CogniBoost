import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Placeholder for sound settings, etc.'),
            // Example: SwitchListTile for a setting
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: true, // Placeholder value
              onChanged: (bool value) {
                // Placeholder for state change
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
