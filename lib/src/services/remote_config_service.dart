import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert'; // For decoding JSON strings

class RemoteConfigService {
  // Singleton pattern
  RemoteConfigService._privateConstructor();
  static final RemoteConfigService _instance = RemoteConfigService._privateConstructor();
  static RemoteConfigService get instance => _instance;

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Default values for Remote Config parameters
  final Map<String, dynamic> _defaultConfig = {
    'available_games': jsonEncode([
      {
        'name': 'Memory Game',
        'route': '/memory_game',
        'enabled': true,
        'params': {'initial_pairs': 6}
      },
      {'name': 'Another Game (Coming Soon)', 'route': '/coming_soon', 'enabled': false}
    ]),
    'memory_game_default_pairs': 8,
    'seasonal_theme_enabled': false,

    // New default for "Today's Game"
    'todays_game_config': jsonEncode({
      "game_id": "default_daily_memory_001",
      "game_type": "memory_game", // Defaulting to memory_game
      "display_name": "Default Daily Memory",
      "description": "A fun memory challenge to start your day!",
      "config": {
        "initial_pairs": 7, // Default pairs for the default today's game
        "icon_theme": "classic"
        // Add other memory game specific defaults if needed
      }
    })
  };

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await _remoteConfig.setDefaults(_defaultConfig);
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1), // For production, consider a longer interval or on app start
      ));
      await _fetchAndActivate();
      _isInitialized = true;
      print('RemoteConfigService initialized successfully.');
      _remoteConfig.onConfigUpdated.listen((event) async {
        print('Remote config updated, activating...');
        await _remoteConfig.activate();
        // Consider adding a stream/notifier here if parts of the app need to react live to config updates
      });
    } catch (e) {
      print('Error initializing RemoteConfigService: $e');
    }
  }

  Future<void> _fetchAndActivate() async {
    try {
      print('Fetching remote config...');
      await _remoteConfig.fetch();
      final bool activated = await _remoteConfig.activate();
      if (activated) {
        print('Remote config activated.');
      } else {
        print('Remote config not activated (already up-to-date or conditions not met).');
      }
    } catch (e) {
      print('Error fetching or activating remote config: $e');
    }
  }

  // --- Getter methods for specific config values ---

  List<Map<String, dynamic>> getAvailableGames() {
    // (Implementation from previous step)
    if (!_isInitialized) {
      print("Warning: Accessing Remote Config before initialization. Returning default games list from local defaults.");
      try { return (jsonDecode(_defaultConfig['available_games'] as String) as List).map((item) => item as Map<String, dynamic>).toList(); }
      catch (e) { print("Error parsing default available_games: $e"); return []; }
    }
    try {
      final String gamesJson = _remoteConfig.getString('available_games');
      if (gamesJson.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(gamesJson);
        return decodedList.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print('Error parsing available_games from Remote Config: $e.');
    } // Fallback to local default if parsing fails or key not found
    return (jsonDecode(_defaultConfig['available_games'] as String) as List).map((item) => item as Map<String, dynamic>).toList();
  }

  bool isSeasonalThemeEnabled() {
    if (!_isInitialized) return _defaultConfig['seasonal_theme_enabled'] as bool;
    return _remoteConfig.getBool('seasonal_theme_enabled');
  }

  int getGlobalMemoryGameDefaultPairs() {
    if (!_isInitialized) return _defaultConfig['memory_game_default_pairs'] as int;
    return _remoteConfig.getInt('memory_game_default_pairs');
  }

  Map<String, dynamic>? getGameConfig(String gameRoute) {
    // (Implementation from previous step)
    final games = getAvailableGames();
    try { return games.firstWhere((game) => game['route'] == gameRoute); }
    catch (e) { return null; }
  }

  // New getter for Today's Game configuration
  Map<String, dynamic>? getTodaysGameConfig() {
    String jsonString;
    if (!_isInitialized) {
      print("Warning: Accessing Remote Config before initialization for Today's Game. Returning local default.");
      jsonString = _defaultConfig['todays_game_config'] as String;
    } else {
      jsonString = _remoteConfig.getString('todays_game_config');
      // If fetched string is empty or not found, fallback to local default string
      if (jsonString.isEmpty) {
        print("Today's Game config is empty in Remote Config, falling back to local default.");
        jsonString = _defaultConfig['todays_game_config'] as String;
      }
    }

    try {
      if (jsonString.isNotEmpty) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error parsing Today's Game JSON: $e. JSON String was: '$jsonString'");
    }
    // Fallback if everything else fails (e.g. default was also bad, though unlikely here)
    return null;
  }
}
