import 'package:flutter/material.dart';

import 'package:belobelo/models/player_model.dart';
import 'package:belobelo/models/question_model.dart';
import 'package:belobelo/widgets/question_widget.dart';
import 'package:belobelo/widgets/timer_widget.dart';

class QuizScreen extends StatelessWidget {
  final String backgroundImagePath;
  final String placeName;
  final Question question;
  final Player player;
  final ValueChanged<bool>? onAnswered;
  final VoidCallback? onTimeUp;
  final Duration timerDuration;

  const QuizScreen({
    super.key,
    required this.backgroundImagePath,
    required this.placeName,
    required this.question,
    required this.player,
    this.onAnswered,
    this.onTimeUp,
    this.timerDuration = const Duration(seconds: 15),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(backgroundImagePath, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: QuestionWidget(
                    question: question,
                    onAnswered: onAnswered,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _PlaceLabel(placeName: placeName),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: TimerWidget(
                    duration: timerDuration,
                    onTimeUp: onTimeUp,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Image.asset(
                    player.imagePath,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceLabel extends StatelessWidget {
  final String placeName;

  const _PlaceLabel({required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Text(
      placeName,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
