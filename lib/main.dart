import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/services/remote_config_service.dart';

import 'src/models/game_stat_model.dart';
import 'src/main_menu/main_menu_screen.dart';
import 'src/settings_screen/settings_screen.dart';
import 'src/level_selection/level_selection_screen.dart';
import 'src/games/memory_game/memory_game_screen.dart';
import 'src/performance_dashboard/performance_dashboard_screen.dart';
import 'src/features/today_game/todays_game_screen.dart'; // New import for Today's Game screen

const String gameStatsBoxName = 'gameStatsBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RemoteConfigService.instance.initialize();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(GameStatModelAdapter().typeId)) {
    Hive.registerAdapter(GameStatModelAdapter());
  }
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
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), // Bolder text
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
        '/levels': (context) => const LevelSelectionScreen(), // May become obsolete or game-specific
        '/memory_game': (context) => const MemoryGameScreen(), // Direct access, or via dynamic list
        '/dashboard': (context) => const PerformanceDashboardScreen(),
        '/coming_soon': (context) => Scaffold(
          appBar: AppBar(title: const Text('Coming Soon')),
          body: const Center(child: Text('This game is coming soon!')),
        ),
        '/todays_game': (context) => const TodaysGameScreen(), // New route for Today's Game
      },
      // Add onGenerateRoute to handle passing arguments to MemoryGameScreen if needed for specific instances
      // This is important if you navigate to /memory_game directly with params from MainMenuScreen's dynamic list
      onGenerateRoute: (settings) {
        if (settings.name == '/memory_game') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) {
              return MemoryGameScreen(gameParams: args);
            },
          );
        }
        // Handle other routes or return null if not handled
        return null;
      },
    );
  }
}
