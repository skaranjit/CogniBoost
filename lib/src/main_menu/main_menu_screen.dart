import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_helper.dart';
import '../services/remote_config_service.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<Map<String, dynamic>> _availableGames = [];
  AdHelper? _adHelper;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadGames();
    _adHelper = AdHelper();
    _bannerAd = _adHelper!.createBannerAd(
        adSize: AdSize.banner,
        onAdLoaded: (Ad ad) {
          if(mounted){
            setState(() {
              _bannerAd = ad as BannerAd;
              _isBannerAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Banner ad failed to load: $error');
          _bannerAd?.dispose();
          _bannerAd = null;
          // No need to setState for _isBannerAdLoaded as it's already false
        }
    );
  }

  void _loadGames() {
    final games = RemoteConfigService.instance.getAvailableGames();
    if (mounted) {
      setState(() {
        // Filter for games explicitly marked as enabled in the general list
        _availableGames = games.where((game) => game['enabled'] == true).toList();
      });
    }
  }

  /*
  Expected JSON structure for 'available_games' in Firebase Remote Config:
  [
    {
      "name": "Memory Game",
      "route": "/memory_game",
      "enabled": true,
      "params": { "initial_pairs": 8, "icon_theme": "classic" }
    },
    // ... other games
  ]
  */

  @override
  void dispose() {
    _bannerAd?.dispose();
    // _adHelper?.dispose(); // AdHelper's dispose is for its own interstitial/rewarded ads
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CogniBoost'), // Simplified title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Prominent button for Today's Game
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // Use primary color for emphasis
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text("🌟 Today's Challenge 🌟"),
                onPressed: () {
                  Navigator.pushNamed(context, '/todays_game');
                },
              ),
              const SizedBox(height: 30),

              // Dynamically loaded general game list (if any enabled)
              if (_availableGames.isEmpty && RemoteConfigService.instance.getAvailableGames().isNotEmpty)
                 const Center(child: Text("Loading other games...", style: TextStyle(color: Colors.grey))),
              if (_availableGames.isEmpty && RemoteConfigService.instance.getAvailableGames().isEmpty)
                 const Center(child: Text("No other games configured yet.", style: TextStyle(color: Colors.grey))),


              ..._availableGames.map((game) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                    ),
                    // Pass game params if the route expects them directly (e.g. for specific MemoryGame instances)
                    // For MemoryGameScreen, it's already set up to receive 'gameParams'
                    onPressed: () => Navigator.pushNamed(
                      context,
                      game['route'] as String,
                      arguments: game['params'] as Map<String,dynamic>?, // Pass params as arguments
                    ),
                    child: Text(game['name'] as String? ?? 'Unnamed Game'),
                  ),
                );
              }).toList(),

              const Spacer(), // Pushes static buttons to the bottom if list is short

              // Static buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                    backgroundColor: MaterialStateProperty.all(theme.colorScheme.secondary.withOpacity(0.8)),
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
                    backgroundColor: MaterialStateProperty.all(theme.colorScheme.secondary.withOpacity(0.8)),
                  ),
                  child: const Text('View Stats'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/stats');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                   style: theme.elevatedButtonTheme.style?.copyWith(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                      backgroundColor: MaterialStateProperty.all(theme.colorScheme.secondary.withOpacity(0.8)),
                    ),
                  child: const Text('Settings'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ),
              if (_isBannerAdLoaded && _bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
