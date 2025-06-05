import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CogniBoost - Main Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Start Memory Game'),
              onPressed: () {
                Navigator.pushNamed(context, '/memory_game');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton( // New Button for Dashboard
              child: const Text('View Progress'),
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Level Selection'),
              onPressed: () {
                Navigator.pushNamed(context, '/levels');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Settings'),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
