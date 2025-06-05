import 'package:flutter/material.dart';
import '../../models/memory_card_model.dart';

// Base list of icons available for cards.
final Map<String, List<IconData>> _iconThemes = {
  'classic': [
    Icons.star, Icons.favorite, Icons.anchor, Icons.bug_report,
    Icons.camera, Icons.lightbulb, Icons.map, Icons.pets,
    Icons.ac_unit, Icons.access_alarm, Icons.account_balance, Icons.adb,
    Icons.airplanemode_active, Icons.all_inclusive, Icons.assessment, Icons.attach_money,
  ],
  'nature': [ // Example of another theme
    Icons.eco, Icons.filter_vintage, Icons.flare, Icons.forest,
    Icons.grass, Icons.landscape, Icons.local_florist, Icons.park,
    Icons.terrain, Icons.wb_sunny, Icons.waves, Icons.wb_cloudy,
    Icons.night_shelter, Icons.self_improvement, Icons.spa, Icons.volcano,
  ],
  // Add more themes as needed
};

List<MemoryCardModel> getInitialCards({
  required int numberOfPairs,
  String iconTheme = 'classic', // Default to 'classic' theme
}) {
  print("Memory Game Logic: Generating cards with $numberOfPairs pairs using theme '$iconTheme'.");

  List<IconData> selectedIconPack = _iconThemes[iconTheme] ?? _iconThemes['classic']!;

  if (numberOfPairs <= 0) {
    return [];
  }
  if (numberOfPairs > selectedIconPack.length) {
    print("Warning: Requested $numberOfPairs pairs for theme '$iconTheme', but only ${selectedIconPack.length} unique icons available. Clamping to max available.");
    numberOfPairs = selectedIconPack.length;
  }

  List<IconData> cardIcons = List<IconData>.from(selectedIconPack.take(numberOfPairs));

  List<MemoryCardModel> cards = [];
  int idCounter = 0;

  for (var icon in cardIcons) {
    cards.add(MemoryCardModel(id: idCounter++, icon: icon));
    cards.add(MemoryCardModel(id: idCounter++, icon: icon));
  }

  cards.shuffle();
  return cards;
}
