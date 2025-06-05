import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/memory_card_model.dart';
import '../../models/game_stat_model.dart';
import 'memory_game_logic.dart';
import '../../../main.dart'; // For gameStatsBoxName
import '../../services/remote_config_service.dart';

class MemoryGameScreen extends StatefulWidget {
  final Map<String, dynamic>? gameParams; // From Remote Config's "config" field for the game

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
  final int _pointsPerMatch = 100; // Could also be made configurable
  final int _penaltyPerMiss = 10;  // Could also be made configurable

  int _actualNumberOfPairs = 8; // Final fallback default
  String _actualIconTheme = 'classic'; // Final fallback default

  late Box<GameStatModel> _gameStatsBox;

  @override
  void initState() {
    super.initState();
    _gameStatsBox = Hive.box<GameStatModel>(gameStatsBoxName);
    _configureAndInitializeGame();
  }

  void _configureAndInitializeGame() {
    // Determine number of pairs:
    // Priority: widget.gameParams -> global Remote Config -> hardcoded default
    int initialPairsConfig = widget.gameParams?['initial_pairs'] as int? ??
                             RemoteConfigService.instance.getGlobalMemoryGameDefaultPairs();
    _actualNumberOfPairs = initialPairsConfig.clamp(2, 10); // Clamp for sanity; max depends on available icons

    // Determine icon theme:
    // Priority: widget.gameParams -> hardcoded default
    _actualIconTheme = widget.gameParams?['icon_theme'] as String? ?? 'classic';

    print("Memory Game Screen: Initializing with $_actualNumberOfPairs pairs, theme '$_actualIconTheme'.");
    _initializeGame();
  }

  void _initializeGame() {
    _cards = getInitialCards(
      numberOfPairs: _actualNumberOfPairs,
      iconTheme: _actualIconTheme,
    );
    _previouslyFlippedCard = null;
    _isProcessingTap = false;
    _pairsFound = 0;
    _numberOfTries = 0;
    _score = 0;
    for (var card in _cards) {
      card.isFaceUp = false;
      card.isMatched = false;
    }
    // Ensure UI rebuilds if _cards list is empty initially (e.g. 0 pairs configured)
    Future.microtask(() => setState(() {}));
  }

  String _getIconName(IconData icon) {
    // This map should be expanded to include icons from ALL themes used.
    // For a more scalable solution, consider a central icon registry or more descriptive icon objects.
    final Map<IconData, String> iconNames = {
      Icons.star: 'Star', Icons.favorite: 'Heart', Icons.anchor: 'Anchor',
      Icons.bug_report: 'Bug', Icons.camera: 'Camera', Icons.lightbulb: 'Lightbulb',
      Icons.map: 'Map', Icons.pets: 'Pets', Icons.ac_unit: 'Snowflake',
      Icons.access_alarm: 'Alarm Clock', Icons.account_balance: 'Bank', Icons.adb: 'Android Bug',
      Icons.airplanemode_active: 'Airplane', Icons.all_inclusive: 'Infinity',
      Icons.assessment: 'Chart', Icons.attach_money: 'Money',
      // Nature Theme Icons (example)
      Icons.eco: 'Eco Leaf', Icons.filter_vintage: 'Vintage Flower', Icons.flare: 'Sun Flare',
      Icons.forest: 'Forest', Icons.grass: 'Grass', Icons.landscape: 'Landscape',
      Icons.local_florist: 'Flower', Icons.park: 'Park Bench', Icons.terrain: 'Mountains',
      Icons.wb_sunny: 'Sun', Icons.waves: 'Waves', Icons.wb_cloudy: 'Cloudy',
      Icons.night_shelter: 'Shelter', Icons.self_improvement: 'Meditation',
      Icons.spa: 'Spa Stones', Icons.volcano: 'Volcano',
    };
    return iconNames[icon] ?? 'Icon';
  }

  // _buildCard, _handleCardTap, _saveGameResult, _showGameEndDialog remain the same as previous step
  // ... (Assume these methods are present and correct from previous versions) ...
  // For brevity, not repeating them here. The key change is in _configureAndInitializeGame and
  // ensuring _getIconName is comprehensive if multiple themes are actively used.

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
      gameName: 'MemoryGame - Theme: $_actualIconTheme', // Example: include theme in saved name
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
                _configureAndInitializeGame();
              },
            ),
            TextButton(
              child: const Text('Main Menu'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Pop game screen
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
    if (_cards.isEmpty && _actualNumberOfPairs > 0) { // Show loading if cards are expected but not ready
        return Scaffold(
            appBar: AppBar(title: Text('Memory Game - $_actualNumberOfPairs Pairs')),
            body: const Center(child: CircularProgressIndicator())
        );
    }
     if (_actualNumberOfPairs <= 0) { // Handle case where 0 pairs are configured
        return Scaffold(
            appBar: AppBar(title: const Text('Memory Game')),
            body: Center(
                child: Text(
                    "No cards to display.\nPlease check game configuration.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium
                )
            )
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game - $_actualNumberOfPairs Pairs ($_actualIconTheme)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _configureAndInitializeGame,
            tooltip: 'Restart Game',
          )
        ],
      ),
      body: Column(
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
                crossAxisCount: (_actualNumberOfPairs <= 6) ? 3 : ((_actualNumberOfPairs <= 12) ? 4 : 5), // Example adjustment
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
