import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Helper to parse color from hex string (basic version)
Color _colorFromHex(String hexColor, {Color defaultColor = Colors.red}) {
  try {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Add alpha if missing
    }
    if (hexColor.length == 8) {
      return Color(int.parse(hexColor, radix: 16));
    }
  } catch (e) {
    print("Error parsing color hex $hexColor: $e");
  }
  return defaultColor;
}

enum GamePhase { countdown, playing, gameOver }

class TapSpeedGameScreen extends StatefulWidget {
  final Map<String, dynamic>? gameParams;

  const TapSpeedGameScreen({super.key, this.gameParams});

  @override
  State<TapSpeedGameScreen> createState() => _TapSpeedGameScreenState();
}

class _TapSpeedGameScreenState extends State<TapSpeedGameScreen> with SingleTickerProviderStateMixin {
  // --- Game Configuration (from gameParams or defaults) ---
  late int _gameDurationSeconds;
  late double _targetRadius;
  late Color _targetColor;

  // --- Game State ---
  GamePhase _gamePhase = GamePhase.countdown;
  int _score = 0;
  int _timeLeft = 0;
  int _countdownTime = 3;
  Timer? _gameTimer;
  Timer? _countdownTimerObj;

  // Target properties
  Offset? _targetPosition; // Position of the center of the target
  final Random _random = Random();
  GlobalKey _gameAreaKey = GlobalKey(); // To get dimensions of the game area

  // Animation for target (optional, simple scale)
  AnimationController? _targetAnimationController;
  Animation<double>? _targetScaleAnimation;


  @override
  void initState() {
    super.initState();
    _loadConfig();
    _timeLeft = _gameDurationSeconds;

    _targetAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100), // Quick pop
      vsync: this,
    );
    _targetScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _targetAnimationController!, curve: Curves.elasticOut)
    );

    // Start countdown after the first frame is built so _gameAreaKey is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCountdown();
    });
  }

  void _loadConfig() {
    _gameDurationSeconds = widget.gameParams?['duration_seconds'] as int? ?? 30;
    _targetRadius = widget.gameParams?['target_radius'] as double? ?? 30.0;
    String colorHex = widget.gameParams?['target_color'] as String? ?? "#FF0000"; // Default Red
    _targetColor = _colorFromHex(colorHex);
  }

  void _startCountdown() {
    if (!mounted) return;
    setState(() {
      _gamePhase = GamePhase.countdown;
      _countdownTime = 3;
    });
    _countdownTimerObj = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _countdownTime--;
        if (_countdownTime <= 0) {
          timer.cancel();
          _startGame();
        }
      });
    });
  }

  void _startGame() {
    if (!mounted) return;
    setState(() {
      _gamePhase = GamePhase.playing;
      _score = 0;
      _timeLeft = _gameDurationSeconds;
    });
    _spawnTarget();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          timer.cancel();
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    if (!mounted) return;
    _targetAnimationController?.reverse();
    setState(() {
      _gamePhase = GamePhase.gameOver;
      _targetPosition = null; // Remove target
    });
    _gameTimer?.cancel();
    _countdownTimerObj?.cancel();
  }

  void _spawnTarget() {
    if (!mounted || _gameAreaKey.currentContext == null) return;
    final RenderBox gameAreaRenderBox = _gameAreaKey.currentContext!.findRenderObject() as RenderBox;
    final gameAreaSize = gameAreaRenderBox.size;

    if (gameAreaSize.width <= _targetRadius * 2 || gameAreaSize.height <= _targetRadius * 2) {
      // Game area too small, handle error or wait
      print("Game area is too small to spawn target.");
      return;
    }

    // Ensure target is fully within bounds
    double x = _random.nextDouble() * (gameAreaSize.width - _targetRadius * 2) + _targetRadius;
    double y = _random.nextDouble() * (gameAreaSize.height - _targetRadius * 2) + _targetRadius;

    setState(() {
      _targetPosition = Offset(x, y);
    });
    _targetAnimationController?.forward(from: 0.0); // Play spawn animation
  }

  void _onTargetTap() {
    if (_gamePhase != GamePhase.playing || !mounted) return;
    _targetAnimationController?.reverse().then((value) {
        if (!mounted) return;
        setState(() {
            _score += 10;
            _targetPosition = null; // Remove current target before spawning next
        });
        _spawnTarget(); // Spawn new target
    });
  }

  void _onGameAreaTap(Offset tapPosition) {
    if (_gamePhase != GamePhase.playing || _targetPosition == null || !mounted) return;

    // Check if tap is on target
    final distance = (tapPosition - _targetPosition!).distance;
    if (distance <= _targetRadius) {
      _onTargetTap();
    } else {
      // Missed tap (optional: add penalty or visual feedback for miss)
      print("Missed tap");
    }
  }

  void _restartGame() {
    _endGame(); // Clean up current game
    _loadConfig(); // Reload config in case it changed (e.g. if screen is kept alive)
    _timeLeft = _gameDurationSeconds;
    WidgetsBinding.instance.addPostFrameCallback((_) { // Ensure UI is ready for countdown
       _startCountdown();
    });
  }


  @override
  void dispose() {
    _gameTimer?.cancel();
    _countdownTimerObj?.cancel();
    _targetAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tap Speed Challenge"),
        backgroundColor: theme.colorScheme.secondary, // Distinct app bar
      ),
      body: Column(
        children: [
          // Top Info Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: theme.primaryColorDark.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Score: $_score", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text("Time: $_timeLeft s", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Game Area
          Expanded(
            child: LayoutBuilder( // Use LayoutBuilder to get constraints for game area
              builder: (context, constraints) {
                // If _gameAreaKey.currentContext is null initially, this helps ensure it's available
                // when _spawnTarget is called after countdown.
                if (_gameAreaKey.currentContext == null && _gamePhase == GamePhase.playing && _targetPosition == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                        if(_gamePhase == GamePhase.playing && _targetPosition == null) _spawnTarget();
                    });
                }
                return GestureDetector(
                  onTapDown: (details) { // Use onTapDown for more immediate feedback on position
                    if (_gamePhase == GamePhase.playing) {
                      _onGameAreaTap(details.localPosition);
                    }
                  },
                  child: Container(
                    key: _gameAreaKey,
                    color: Colors.grey[200], // Game area background
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        // Target
                        if (_targetPosition != null && (_gamePhase == GamePhase.playing || _targetAnimationController?.isAnimating == true))
                          Positioned(
                            left: _targetPosition!.dx - _targetRadius,
                            top: _targetPosition!.dy - _targetRadius,
                            child: ScaleTransition(
                              scale: _targetScaleAnimation!,
                              child: Container(
                                width: _targetRadius * 2,
                                height: _targetRadius * 2,
                                decoration: BoxDecoration(
                                  color: _targetColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                        // Countdown / Game Over UI
                        if (_gamePhase == GamePhase.countdown)
                          Center(
                            child: Text(
                              "$_countdownTime",
                              style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                            ),
                          ),
                        if (_gamePhase == GamePhase.gameOver)
                          Center(
                            child: Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Time's Up!",
                                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.error),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Final Score: $_score",
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: _restartGame,
                                          child: const Text("Play Again"),
                                        ),
                                        const SizedBox(width: 15),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text("Main Menu"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
