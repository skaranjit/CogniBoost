import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';

class RemoteConfigService {
  RemoteConfigService._privateConstructor();
  static final RemoteConfigService _instance = RemoteConfigService._privateConstructor();
  static RemoteConfigService get instance => _instance;

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  final Map<String, dynamic> _defaultConfig = {
    'available_games': jsonEncode([
      {
        'name': 'Memory Game',
        'route': '/memory_game',
        'enabled': true,
        'params': {'initial_pairs': 6, 'icon_theme': 'classic'}
      },
      { // New entry for Tap Speed Challenge in the general list
        'name': 'Tap Speed Challenge',
        'route': '/tap_speed_challenge', // Needs a route in main.dart
        'enabled': true,
        'params': {'duration_seconds': 30, 'target_radius': 25.0, 'target_color': "#0000FF"} // Blue
      }
    ]),
    'memory_game_default_pairs': 8,
    'seasonal_theme_enabled': false,
    'todays_game_config': jsonEncode({ // Example: Today's game is Tap Speed Challenge
      "game_id": "daily_tap_speed_001",
      "game_type": "tap_speed_challenge",
      "display_name": "Daily Tap Frenzy",
      "description": "How fast can you tap today?",
      "config": {
        "duration_seconds": 20, // Shorter duration for daily challenge
        "target_radius": 35.0, // Slightly larger target
        "target_color": "#FF8C00" // Dark Orange
      }
    })
  };

  bool _isInitialized = false;

  Future<void> initialize() async {
    // ... (initialize method remains the same as previous step)
    if (_isInitialized) return;
    try {
      await _remoteConfig.setDefaults(_defaultConfig);
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await _fetchAndActivate();
      _isInitialized = true;
      print('RemoteConfigService initialized successfully.');
      _remoteConfig.onConfigUpdated.listen((event) async {
        print('Remote config updated, activating...');
        await _remoteConfig.activate();
      });
    } catch (e) {
      print('Error initializing RemoteConfigService: $e');
    }
  }

  Future<void> _fetchAndActivate() async {
    // ... (_fetchAndActivate method remains the same)
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

  List<Map<String, dynamic>> getAvailableGames() {
    // ... (getAvailableGames method remains the same)
    if (!_isInitialized) {
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
    }
    return (jsonDecode(_defaultConfig['available_games'] as String) as List).map((item) => item as Map<String, dynamic>).toList();
  }

  Map<String, dynamic>? getTodaysGameConfig() {
    // ... (getTodaysGameConfig method remains the same)
    String jsonString;
    if (!_isInitialized) {
      jsonString = _defaultConfig['todays_game_config'] as String;
    } else {
      jsonString = _remoteConfig.getString('todays_game_config');
      if (jsonString.isEmpty) {
        jsonString = _defaultConfig['todays_game_config'] as String;
      }
    }
    try {
      if (jsonString.isNotEmpty) { return jsonDecode(jsonString) as Map<String, dynamic>; }
    } catch (e) { print("Error parsing Today's Game JSON: $e. JSON String was: '$jsonString'");}
    return null;
  }

  // Other getters (isSeasonalThemeEnabled, getGlobalMemoryGameDefaultPairs, getGameConfig) remain the same
   bool isSeasonalThemeEnabled() {
    if (!_isInitialized) return _defaultConfig['seasonal_theme_enabled'] as bool;
    return _remoteConfig.getBool('seasonal_theme_enabled');
  }

  int getGlobalMemoryGameDefaultPairs() {
    if (!_isInitialized) return _defaultConfig['memory_game_default_pairs'] as int;
    return _remoteConfig.getInt('memory_game_default_pairs');
  }

  Map<String, dynamic>? getGameConfig(String gameRoute) {
    final games = getAvailableGames();
    try { return games.firstWhere((game) => game['route'] == gameRoute); }
    catch (e) { return null; }
  }
}
