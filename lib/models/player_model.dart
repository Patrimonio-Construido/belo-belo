import 'package:flutter/material.dart';

class Player {
  final String slug;
  final Color color;
  int boardSquareIndex;

  Player({
    required this.slug,
    required this.color,
    required this.boardSquareIndex,
  });

  String get imagePath {
    switch (slug) {
      case 'Gato':
        return 'assets/images/gato/Gato-01.png';
      case 'Menina':
        return 'assets/images/menina/Menina_01.png';
      default:
        throw ArgumentError('No image known for player slug "$slug"');
    }
  }
}
