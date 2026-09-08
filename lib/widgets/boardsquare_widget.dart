import 'package:flutter/material.dart';

import 'package:belobelo/models/boardsquare_model.dart';

extension _BoardSquareStyle on BoardSquareType {
  Color get color {
    switch (this) {
      case BoardSquareType.start:
        return const Color(0xFF7A9B6E); // muted sage green
      case BoardSquareType.end:
        return const Color(0xFF4A3F5C); // deep charcoal-plum
      case BoardSquareType.normal:
        return const Color(0xFF8A7CA8); // dusty mauve/purple
      case BoardSquareType.bonus:
        return const Color(0xFFC9A961); // warm gold/olive
      case BoardSquareType.penalty:
        return const Color(0xFFC97B5A); // muted terracotta
    }
  }

  IconData? get glyph {
    switch (this) {
      case BoardSquareType.start:
        return Icons.flag;
      case BoardSquareType.end:
        return Icons.flag;
      case BoardSquareType.normal:
        return null;
      case BoardSquareType.bonus:
        return Icons.star;
      case BoardSquareType.penalty:
        return Icons.priority_high;
    }
  }

  double get sizeMultiplier {
    switch (this) {
      case BoardSquareType.start:
      case BoardSquareType.end:
        return 1.3;
      case BoardSquareType.normal:
      case BoardSquareType.bonus:
      case BoardSquareType.penalty:
        return 1.0;
    }
  }
}

class BoardSquareWidget extends StatelessWidget {
  final BoardSquare boardSquare;
  final double size;

  const BoardSquareWidget({
    super.key,
    required this.boardSquare,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final color = boardSquare.type.color;
    final glyph = boardSquare.type.glyph;
    final tileSize = size * boardSquare.type.sizeMultiplier;

    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(tileSize * 0.18),
        border: Border.all(color: Colors.black12, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: glyph == null ? null : Icon(glyph, size: tileSize * 0.5, color: Colors.white),
    );
  }
}
