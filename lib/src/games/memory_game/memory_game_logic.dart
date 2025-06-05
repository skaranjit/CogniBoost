import 'package:flutter/material.dart';
import '../../models/memory_card_model.dart';

List<MemoryCardModel> getInitialCards() {
  List<IconData> cardIcons = [
    Icons.star, Icons.favorite, Icons.anchor, Icons.bug_report,
    Icons.camera, Icons.lightbulb, Icons.map, Icons.pets,
    // Add more pairs as needed
  ];

  List<MemoryCardModel> cards = [];
  int idCounter = 0;

  for (var icon in cardIcons) {
    cards.add(MemoryCardModel(id: idCounter++, icon: icon));
    cards.add(MemoryCardModel(id: idCounter++, icon: icon)); // Add the pair
  }

  cards.shuffle(); // Shuffle the cards
  return cards;
}
