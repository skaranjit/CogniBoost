import 'package:flutter/material.dart';
import 'package:cogniboost_app/src/main_menu/main_menu_screen.dart';
import 'package:cogniboost_app/src/game_screen/game_screen.dart';
import 'package:cogniboost_app/src/settings_screen/settings_screen.dart';
import 'package:cogniboost_app/src/level_selection/level_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CogniBoost App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/levels': (context) => const LevelSelectionScreen(),
      },
    );
  }
}
