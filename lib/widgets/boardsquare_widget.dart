import 'package:flutter/material.dart';

import 'package:belobelo/models/boardsquare_model.dart';

extension _BoardSpaceStyle on BoardSpaceType {
  Color get color {
    switch (this) {
      case BoardSpaceType.start:
        return const Color(0xFF7A9B6E); // muted sage green
      case BoardSpaceType.end:
        return const Color(0xFF4A3F5C); // deep charcoal-plum
      case BoardSpaceType.normal:
        return const Color(0xFF8A7CA8); // dusty mauve/purple
      case BoardSpaceType.bonus:
        return const Color(0xFFC9A961); // warm gold/olive
      case BoardSpaceType.penalty:
        return const Color(0xFFC97B5A); // muted terracotta
    }
  }

  IconData? get glyph {
    switch (this) {
      case BoardSpaceType.start:
        return Icons.flag;
      case BoardSpaceType.end:
        return Icons.flag;
      case BoardSpaceType.normal:
        return null;
      case BoardSpaceType.bonus:
        return Icons.star;
      case BoardSpaceType.penalty:
        return Icons.priority_high;
    }
  }

  double get sizeMultiplier {
    switch (this) {
      case BoardSpaceType.start:
      case BoardSpaceType.end:
        return 1.3;
      case BoardSpaceType.normal:
      case BoardSpaceType.bonus:
      case BoardSpaceType.penalty:
        return 1.0;
    }
  }
}

class BoardSpaceWidget extends StatelessWidget {
  final BoardSpace boardSpace;
  final double size;

  const BoardSpaceWidget({
    super.key,
    required this.boardSpace,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final color = boardSpace.type.color;
    final glyph = boardSpace.type.glyph;
    final tileSize = size * boardSpace.type.sizeMultiplier;

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
