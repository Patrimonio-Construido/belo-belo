import 'package:flutter/material.dart';

import 'package:belobelo/models/player_model.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  final double size;

  const PlayerWidget({super.key, required this.player, this.size = 64});

  @override
  Widget build(BuildContext context) {
    const ringWidth = 4.0;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(ringWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: player.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: player.color,
          padding: const EdgeInsets.all(4),
          child: Image.asset(player.imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
