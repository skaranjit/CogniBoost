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
        'name': 'Memory Game', // Updated default name slightly for clarity
        'route': '/memory_game',
        'enabled': true,
        // Nested 'params' for game-specific configurations
        'params': {'initial_pairs': 6} // Default initial pairs for this game instance
      },
      {'name': 'Another Game (Coming Soon)', 'route': '/coming_soon', 'enabled': false}
    ]),
    // Global default, can be overridden by 'params' in available_games
    'memory_game_default_pairs': 8,
    'seasonal_theme_enabled': false,
  };

  bool _isInitialized = false;

  Future<void> initialize() async {
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
    try {
      print('Fetching remote config...');
      await _remoteConfig.fetch();
      final bool activated = await _remoteConfig.activate();
      if (activated) {
        print('Remote config activated.');
      } else {
        print('Remote config not activated.');
      }
    } catch (e) {
      print('Error fetching or activating remote config: $e');
    }
  }

  List<Map<String, dynamic>> getAvailableGames() {
    // ... (previous implementation of getAvailableGames - no changes needed here for this step) ...
    // For brevity, assuming the previous robust implementation is here.
    // This is just a placeholder to keep the snippet shorter.
    // The actual robust getter from the previous step should be used.
     if (!_isInitialized) {
      print("Warning: Accessing Remote Config before initialization. Returning default games list from local defaults.");
      try {
        return (jsonDecode(_defaultConfig['available_games'] as String) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } catch (e) { return []; }
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
    return (jsonDecode(_defaultConfig['available_games'] as String) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
  }

  bool isSeasonalThemeEnabled() {
    if (!_isInitialized) return _defaultConfig['seasonal_theme_enabled'] as bool;
    return _remoteConfig.getBool('seasonal_theme_enabled');
  }

  // Getter for the global default pairs for memory game
  int getGlobalMemoryGameDefaultPairs() {
    if (!_isInitialized) return _defaultConfig['memory_game_default_pairs'] as int;
    return _remoteConfig.getInt('memory_game_default_pairs');
  }

  // Helper to get a specific game's config from the available_games list
  // This is useful if 'params' are nested within each game entry.
  Map<String, dynamic>? getGameConfig(String gameRoute) {
    final games = getAvailableGames();
    try {
      return games.firstWhere((game) => game['route'] == gameRoute);
    } catch (e) {
      return null; // Game not found
    }
  }
}
