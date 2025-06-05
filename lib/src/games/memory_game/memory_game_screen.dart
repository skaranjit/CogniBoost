import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/memory_card_model.dart';
import '../../models/game_stat_model.dart';
import 'memory_game_logic.dart';
import '../../../main.dart'; // For gameStatsBoxName
import '../../services/remote_config_service.dart'; // Import RemoteConfigService

class MemoryGameScreen extends StatefulWidget {
  // Optional: Allow passing game-specific params, e.g., from MainMenuScreen
  final Map<String, dynamic>? gameParams;

  const MemoryGameScreen({super.key, this.gameParams});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<MemoryCardModel> _cards;
  MemoryCardModel? _previouslyFlippedCard;
  bool _isProcessingTap = false;
  int _pairsFound = 0;
  int _numberOfTries = 0;
  int _score = 0;
  final int _pointsPerMatch = 100;
  final int _penaltyPerMiss = 10;
  int _actualNumberOfPairs = 8; // Local default

  late Box<GameStatModel> _gameStatsBox;

  @override
  void initState() {
    super.initState();
    _gameStatsBox = Hive.box<GameStatModel>(gameStatsBoxName);
    _configureAndInitializeGame();
  }

  void _configureAndInitializeGame() {
    // Determine number of pairs:
    // 1. Check widget.gameParams (passed via navigation)
    // 2. Fallback to global Remote Config default for memory game
    // 3. Fallback to local hardcoded default
    int initialPairs = widget.gameParams?['initial_pairs'] as int? ??
                       RemoteConfigService.instance.getGlobalMemoryGameDefaultPairs();

    // Ensure it's a reasonable value, e.g., not less than 2, not more than available icons
    _actualNumberOfPairs = initialPairs.clamp(2, 10); // Clamp between 2 and 10 pairs for this example. Adjust as needed.

    print("Memory Game: Initializing with $_actualNumberOfPairs pairs.");
    _initializeGame();
  }

  void _initializeGame() {
    _cards = getInitialCards(numberOfPairs: _actualNumberOfPairs); // Use fetched/defaulted number of pairs
    _previouslyFlippedCard = null;
    _isProcessingTap = false;
    _pairsFound = 0;
    _numberOfTries = 0;
    _score = 0;
    for (var card in _cards) {
      card.isFaceUp = false;
      card.isMatched = false;
    }
    Future.microtask(() => setState(() {}));
  }

  // ... (rest of _buildCard, _handleCardTap, _saveGameResult, _showGameEndDialog, build method remain largely the same)
  // Ensure _getIconName in _buildCard can handle all icons from _availableIcons in memory_game_logic.dart
  // For brevity, only showing relevant changes. Assume other methods are present from previous steps.

  String _getIconName(IconData icon) {
    // Basic mapping for semantics. More robust mapping might be needed for more icons.
    if (icon == Icons.star) return 'Star';
    if (icon == Icons.favorite) return 'Heart';
    if (icon == Icons.anchor) return 'Anchor';
    if (icon == Icons.bug_report) return 'Bug';
    if (icon == Icons.camera) return 'Camera';
    if (icon == Icons.lightbulb) return 'Lightbulb';
    if (icon == Icons.map) return 'Map';
    if (icon == Icons.pets) return 'Pets';
    if (icon == Icons.ac_unit) return 'Snowflake';
    if (icon == Icons.access_alarm) return 'Alarm Clock';
    if (icon == Icons.account_balance) return 'Bank';
    if (icon == Icons.adb) return 'Android Bug';
    if (icon == Icons.airplanemode_active) return 'Airplane';
    if (icon == Icons.all_inclusive) return 'Infinity';
    if (icon == Icons.assessment) return 'Chart';
    if (icon == Icons.attach_money) return 'Money';
    return 'Icon'; // Default
  }

  Widget _buildCard(BuildContext context, int index) {
    final card = _cards[index];
    final theme = Theme.of(context);
    Widget cardFace;
    Color cardColor;
    String semanticLabel;

    if (card.isMatched) {
      final iconName = _getIconName(card.icon);
      cardFace = Icon(card.icon, size: 40.0, color: theme.colorScheme.primary);
      cardColor = theme.colorScheme.primaryContainer.withOpacity(0.5);
      semanticLabel = '$iconName icon, matched.';
    } else if (card.isFaceUp) {
      final iconName = _getIconName(card.icon);
      cardFace = Icon(card.icon, size: 40.0, color: theme.colorScheme.secondary);
      cardColor = theme.cardTheme.color ?? theme.cardColor;
      semanticLabel = '$iconName icon, face up.';
    } else {
      cardFace = Icon(Icons.question_mark, size: 40.0, color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6));
      cardColor = theme.cardTheme.color?.withOpacity(0.8) ?? theme.disabledColor;
      semanticLabel = 'Card face down.';
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      child: GestureDetector(
        onTap: () => _handleCardTap(index),
        child: Card(
          color: cardColor,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Container(
                key: ValueKey<String>("${card.id}_${card.isFaceUp}_${card.isMatched}"),
                child: cardFace,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCardTap(int index) {
    if (_isProcessingTap || _cards[index].isFaceUp || _cards[index].isMatched) {
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _cards[index].isFaceUp = true;
      _isProcessingTap = true;
    });

    if (_previouslyFlippedCard == null) {
      _previouslyFlippedCard = _cards[index];
      setState(() { _isProcessingTap = false; });
    } else {
      _numberOfTries++;
      if (_previouslyFlippedCard!.icon == _cards[index].icon && _previouslyFlippedCard!.id != _cards[index].id) {
        setState(() {
          _cards[index].isMatched = true;
          _previouslyFlippedCard!.isMatched = true;
          _pairsFound++;
          _score += _pointsPerMatch;
          _previouslyFlippedCard = null;
          _isProcessingTap = false;
        });
        if (_pairsFound == (_cards.length ~/ 2)) {
          _saveGameResult();
          _showGameEndDialog();
        }
      } else {
        _score = (_score - _penaltyPerMiss).clamp(0, _score);
        Timer(const Duration(milliseconds: 1000), () {
          if (mounted && !_cards[index].isMatched && (_previouslyFlippedCard != null && !_previouslyFlippedCard!.isMatched)) {
            setState(() {
              _cards[index].isFaceUp = false;
              _previouslyFlippedCard?.isFaceUp = false;
              _previouslyFlippedCard = null;
            });
          }
          if (mounted) { setState(() { _isProcessingTap = false; }); }
        });
      }
    }
  }

  Future<void> _saveGameResult() async {
    final gameStat = GameStatModel(
      gameName: 'MemoryGame', // Could also be made dynamic via widget.gameParams
      score: _score,
      tries: _numberOfTries,
      timestamp: DateTime.now(),
    );
    await _gameStatsBox.add(gameStat);
  }

  void _showGameEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Level Complete!'),
          content: Text('You found all pairs in $_numberOfTries tries.\nYour Score: $_score'),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _configureAndInitializeGame(); // Re-configure and re-initialize
              },
            ),
            TextButton(
              child: const Text('Main Menu'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_cards.isEmpty) { // Handle case where cards are not yet initialized or 0 pairs
        return Scaffold(
            appBar: AppBar(title: const Text('Memory Game')),
            body: const Center(child: CircularProgressIndicator())
        );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game - $_actualNumberOfPairs Pairs'), // Dynamic title
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _configureAndInitializeGame, // Refresh uses new config method
            tooltip: 'Restart Game',
          )
        ],
      ),
      body: Column(
        // ... (rest of the UI from previous step, e.g., score display, GridView)
        // Ensure GridView crossAxisCount is appropriate for potentially more/fewer cards
         children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Pairs: $_pairsFound / ${_cards.length ~/ 2}', style: theme.textTheme.titleMedium),
                Text('Tries: $_numberOfTries', style: theme.textTheme.titleMedium),
                Text('Score: $_score', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // Adjust crossAxisCount based on _actualNumberOfPairs or screen size
                crossAxisCount: (_actualNumberOfPairs <= 6) ? 3 : 4, // Example adjustment
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _cards.length,
              itemBuilder: _buildCard,
            ),
          ),
        ],
      ),
    );
  }
}
