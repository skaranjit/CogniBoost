import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/models/game_stat_model.dart';
import 'src/main_menu/main_menu_screen.dart';
import 'src/settings_screen/settings_screen.dart';
import 'src/level_selection/level_selection_screen.dart';
import 'src/games/memory_game/memory_game_screen.dart';
import 'src/performance_dashboard/performance_dashboard_screen.dart'; // New import

const String gameStatsBoxName = 'gameStatsBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GameStatModelAdapter());
  await Hive.openBox<GameStatModel>(gameStatsBoxName);
  runApp(const CogniBoostApp());
}

class CogniBoostApp extends StatelessWidget {
  const CogniBoostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CogniBoost App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade700,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/levels': (context) => const LevelSelectionScreen(),
        '/memory_game': (context) => const MemoryGameScreen(),
        '/dashboard': (context) => const PerformanceDashboardScreen(), // New route
      },
    );
  }
}
