import 'package:flutter/material.dart';
import '../../services/remote_config_service.dart'; // Import the service

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<Map<String, dynamic>> _availableGames = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
    // Optional: If RemoteConfigService has a way to notify listeners of updates,
    // subscribe here and call _loadGames() again.
    // For now, we assume config is fetched by the time this screen loads.
  }

  void _loadGames() {
    final games = RemoteConfigService.instance.getAvailableGames();
    if (mounted) {
      setState(() {
        _availableGames = games.where((game) => game['enabled'] == true).toList();
      });
    }
  }

  /*
  Expected JSON structure for 'available_games' in Firebase Remote Config:
  [
    {
      "name": "Memory Game",    // Display name of the game
      "route": "/memory_game",  // Flutter route for the game
      "enabled": true,          // Whether the game is currently active
      "params": {               // Optional game-specific parameters
        "pairs": 8              // e.g., default number of pairs for memory game
      }
    },
    {
      "name": "Puzzle Game",
      "route": "/puzzle_game",  // Ensure this route is defined in main.dart if enabled
      "enabled": false,
      "description": "A new challenging puzzle!" // Example of another custom field
    },
    {
      "name": "Coming Soon Game",
      "route": "/coming_soon",
      "enabled": true
    }
  ]
  */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CogniBoost - Main Menu'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch
            children: <Widget>[
              if (_availableGames.isEmpty)
                const Center(child: CircularProgressIndicator()), // Show loading or if no games enabled

              ..._availableGames.map((game) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                    ),
                    child: Text(game['name'] as String? ?? 'Unnamed Game'),
                    onPressed: () {
                      final route = game['route'] as String?;
                      if (route != null && route.isNotEmpty) {
                        // Check if route exists before navigating (optional but good practice)
                        // This basic check assumes routes are well-defined in main.dart
                        if (ModalRoute.of(context)?.settings.name != route) {
                           Navigator.pushNamed(context, route);
                        } else {
                           print("Already on route: $route");
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('This game is not configured correctly.')),
                        );
                      }
                    },
                  ),
                );
              }).toList(),

              const SizedBox(height: 30), // Spacer

              // Static buttons (Progress, Settings) can remain or also be made dynamic
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                       backgroundColor: MaterialStateProperty.all(theme.colorScheme.secondary),
                    ),
                  child: const Text('View Progress'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                   style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                      backgroundColor: MaterialStateProperty.all(theme.colorScheme.secondary),
                    ),
                  child: const Text('Settings'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
              // The "Level Selection" button might become obsolete or change
              // if levels are part of individual game configurations.
              // For now, I'll comment it out as its role is less clear with dynamic games.
              /*
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Level Selection'),
                onPressed: () {
                  Navigator.pushNamed(context, '/levels');
                },
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
