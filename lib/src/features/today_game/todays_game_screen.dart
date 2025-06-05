import 'package:flutter/material.dart';
import '../../services/remote_config_service.dart';
import '../../games/memory_game/memory_game_screen.dart';
import '../../games/tap_speed_challenge/tap_speed_game_screen.dart'; // Import TapSpeedGameScreen

// Game Widget Factory / Renderer
Widget _getGameWidget(BuildContext context, String gameType, Map<String, dynamic> config) {
  print("Attempting to render game type: '$gameType' with config: $config");

  switch (gameType.toLowerCase()) {
    case 'memory_game':
      return MemoryGameScreen(gameParams: config);

    case 'tap_speed_challenge': // New case for Tap Speed Challenge
      return TapSpeedGameScreen(gameParams: config);

    default:
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 50),
            const SizedBox(height: 10),
            Text("Game Type Not Supported", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade700,), textAlign: TextAlign.center,),
            const SizedBox(height: 5),
            Text("The game type '$gameType' is not currently supported.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700),),
          ],
        ),
      );
  }
}

// ... (Rest of TodaysGameScreen remains the same)
// For brevity, only the updated _getGameWidget is shown.
// The rest of the TodaysGameScreen class (StatefulWidget, _loadTodaysGame, build, _buildContent)
// is assumed to be present from the previous step.

class TodaysGameScreen extends StatefulWidget {
  const TodaysGameScreen({super.key});

  @override
  State<TodaysGameScreen> createState() => _TodaysGameScreenState();
}

class _TodaysGameScreenState extends State<TodaysGameScreen> {
  Map<String, dynamic>? _todaysGameConfig;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTodaysGame();
  }

  Future<void> _loadTodaysGame() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _todaysGameConfig = null;
    });

    try {
      final config = RemoteConfigService.instance.getTodaysGameConfig();
      if (!mounted) return;

      if (config == null || config.isEmpty) {
        _errorMessage = "No game challenge available for today. Please check back later!";
      } else {
        final gameType = config['game_type'] as String?;
        final displayName = config['display_name'] as String?;
        final gameSpecificConfig = config['config'];

        if (gameType == null || gameType.isEmpty) {
          _errorMessage = "Today's game configuration is invalid (missing 'game_type').";
        } else if (displayName == null || displayName.isEmpty) {
          _errorMessage = "Today's game configuration is invalid (missing 'display_name').";
        } else if (gameSpecificConfig != null && gameSpecificConfig is! Map<String,dynamic>) {
             _errorMessage = "Today's game configuration is invalid ('config' is not structured correctly).";
        } else {
          _todaysGameConfig = config;
        }
      }
    } catch (e) {
      print("Error loading Today's Game config from service: $e");
      _errorMessage = "Could not load today's game due to a technical issue. Please try again.";
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String appBarTitle = "Today's Challenge";
    if (!_isLoading && _todaysGameConfig != null && _todaysGameConfig!['display_name'] != null) {
        appBarTitle = _todaysGameConfig!['display_name'] as String;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTodaysGame,
            tooltip: "Refresh Today's Game",
          )
        ],
      ),
      body: Center(
        child: _buildContent(context, theme),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    if (_errorMessage != null) {
      return Padding( /* ... Error UI ... */
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Icon(Icons.error_outline, color: Colors.red.shade400, size: 70),
             const SizedBox(height: 20),
            Text("Oops! Something went wrong.", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            Text(_errorMessage!, textAlign: TextAlign.center, style: theme.textTheme.titleMedium,),
            const SizedBox(height: 30),
            ElevatedButton.icon(icon: const Icon(Icons.refresh), label: const Text("Try Again"), onPressed: _loadTodaysGame,)
          ],
        ),
      );
    }

    if (_todaysGameConfig == null) {
      return Padding( /* ... No game data UI ... */
        padding: const EdgeInsets.all(16.0),
        child: Text("No game data loaded. Try refreshing.", textAlign: TextAlign.center,style: theme.textTheme.headlineSmall,),
      );
    }

    final String gameType = _todaysGameConfig!['game_type'] as String;
    final String displayName = _todaysGameConfig!['display_name'] as String;
    final String description = _todaysGameConfig!['description'] as String? ?? 'No specific description for this challenge.';
    final Map<String, dynamic> gameSpecificConfig = _todaysGameConfig!['config'] as Map<String, dynamic>? ?? {};

    return Padding( /* ... Game display UI ... */
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(displayName, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary), textAlign: TextAlign.center,),
          const SizedBox(height: 8),
          Text(description, style: theme.textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
          const SizedBox(height: 15),
          const Divider(thickness: 1),
          const SizedBox(height: 15),
          Expanded(child: _getGameWidget(context, gameType, gameSpecificConfig), ),
          const SizedBox(height: 10),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("Game ID: ${_todaysGameConfig!['game_id'] ?? 'N/A'} | Type: $gameType", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600), textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}
