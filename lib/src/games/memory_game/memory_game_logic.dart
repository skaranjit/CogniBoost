import 'package:flutter/material.dart';
import '../../models/memory_card_model.dart';

// Base list of icons available for cards. Ensure enough unique icons for max pairs.
final List<IconData> _availableIcons = [
  Icons.star, Icons.favorite, Icons.anchor, Icons.bug_report,
  Icons.camera, Icons.lightbulb, Icons.map, Icons.pets,
  Icons.ac_unit, Icons.access_alarm, Icons.account_balance, Icons.adb,
  Icons.airplanemode_active, Icons.all_inclusive, Icons.assessment, Icons.attach_money,
  // Add more unique icons if you expect to configure more than 16 pairs
];

List<MemoryCardModel> getInitialCards({required int numberOfPairs}) {
  if (numberOfPairs <= 0) {
    return [];
  }
  if (numberOfPairs > _availableIcons.length) {
    print("Warning: Requested $numberOfPairs pairs, but only ${_availableIcons.length} unique icons available. Clamping to max available.");
    numberOfPairs = _availableIcons.length;
  }

  // Take a subset of available icons based on numberOfPairs
  List<IconData> cardIcons = List<IconData>.from(_availableIcons.take(numberOfPairs));

  List<MemoryCardModel> cards = [];
  int idCounter = 0;

  for (var icon in cardIcons) {
    cards.add(MemoryCardModel(id: idCounter++, icon: icon));
    cards.add(MemoryCardModel(id: idCounter++, icon: icon)); // Add the pair
  }

  cards.shuffle(); // Shuffle the cards
  return cards;
}
