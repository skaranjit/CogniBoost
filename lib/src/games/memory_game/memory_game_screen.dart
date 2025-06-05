import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import '../../models/memory_card_model.dart';
import '../../models/game_stat_model.dart';
import 'memory_game_logic.dart';
import '../../../main.dart'; // For gameStatsBoxName

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

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

  late Box<GameStatModel> _gameStatsBox;

  @override
  void initState() {
    super.initState();
    _gameStatsBox = Hive.box<GameStatModel>(gameStatsBoxName);
    _initializeGame();
  }

  void _initializeGame() {
    _cards = getInitialCards();
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

    return Semantics( // Added Semantics widget
      label: semanticLabel,
      button: true, // Indicate it's interactive like a button
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
      gameName: 'MemoryGame',
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
                _initializeGame();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game - Level 1'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
            tooltip: 'Restart Game', // Tooltip provides accessibility
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
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 4,
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
