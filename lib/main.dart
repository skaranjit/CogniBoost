import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/services/remote_config_service.dart';

// ... other imports for screens ...
import 'src/main_menu/main_menu_screen.dart';
import 'src/settings_screen/settings_screen.dart';
import 'src/level_selection/level_selection_screen.dart';
import 'src/games/memory_game/memory_game_screen.dart';
import 'src/performance_dashboard/performance_dashboard_screen.dart';
import 'src/features/today_game/todays_game_screen.dart';
import 'src/games/tap_speed_challenge/tap_speed_game_screen.dart';
import 'src/models/game_stat_model.dart';


const String gameStatsBoxName = 'gameStatsBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await RemoteConfigService.instance.initialize();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(GameStatModelAdapter().typeId)) { // Check before registering
     Hive.registerAdapter(GameStatModelAdapter());
  }
  await Hive.openBox<GameStatModel>(gameStatsBoxName);
  runApp(const CogniBoostApp());
}

class CogniBoostApp extends StatelessWidget {
  const CogniBoostApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a base text theme using GoogleFonts.nunitoTextTheme()
    // This provides a good starting point.
    final baseTextTheme = GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme);

    // Further customize specific text styles if needed
    final customTextTheme = baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
      bodyLarge: baseTextTheme.bodyLarge,
      bodyMedium: baseTextTheme.bodyMedium,
      labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5), // For buttons
    );


    return MaterialApp(
      title: 'CogniBoost App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Keeping this for now, can be part of a larger color palette update
        // Apply the custom text theme
        textTheme: customTextTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade700,
          foregroundColor: Colors.white,
          // Apply custom font to AppBar titles as well
          titleTextStyle: customTextTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            // Use the labelLarge style from the custom text theme for button text
            textStyle: customTextTheme.labelLarge,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          color: Colors.white,
        ),
        // You might want to define colorScheme explicitly if doing a full color overhaul
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: Colors.orangeAccent),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/levels': (context) => const LevelSelectionScreen(),
        '/dashboard': (context) => const PerformanceDashboardScreen(),
        '/coming_soon': (context) => Scaffold(
            appBar: AppBar(title: const Text('Coming Soon')), // Will use themed text
            body: const Center(child: Text('This game is coming soon!'))), // Will use themed text
        '/todays_game': (context) => const TodaysGameScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/memory_game':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => MemoryGameScreen(gameParams: args),
            );
          case '/tap_speed_challenge':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => TapSpeedGameScreen(gameParams: args),
            );
          default:
            // If no route is defined for a name, you might want to navigate to a 404 page
            // For now, assert false or return null to see the error during development.
            // assert(false, 'Need to implement ${settings.name}');
            return MaterialPageRoute(
                builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Error')),
                    body: Center(child: Text('Route ${settings.name} not found or requires arguments that were not provided.'))));
        }
      },
    );
  }
}
