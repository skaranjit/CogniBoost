import 'package:flutter/material.dart';

class MemoryCardModel {
  final int id;
  final IconData icon;
  bool isFaceUp;
  bool isMatched;

  MemoryCardModel({
    required this.id,
    required this.icon,
    this.isFaceUp = false,
    this.isMatched = false,
  });
}
