import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:belobelo/models/question_model.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final ValueChanged<bool>? onAnswered;

  const QuestionWidget({super.key, required this.question, this.onAnswered});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  static const _neutralColor = Color(0xFF8A7CA8); // dusty mauve/purple
  static const _correctColor = Color(0xFF7A9B6E); // muted sage green
  static const _wrongColor = Color(0xFFC97B5A); // muted terracotta
  static final _disabledColor =
      const Color(0xFF4A3F5C).withValues(alpha: 0.55); // deep charcoal-plum, faded

  final _correctPlayer = AudioPlayer();
  final _incorrectPlayer = AudioPlayer();

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Low-latency mode + preloading avoids the multi-second first-play delay
    // MediaPlayer-backed playback has on Android when loading the asset on tap.
    _correctPlayer.setPlayerMode(PlayerMode.lowLatency);
    _incorrectPlayer.setPlayerMode(PlayerMode.lowLatency);
    _correctPlayer.setSource(AssetSource('sounds/quiz/correct_choice.wav'));
    _incorrectPlayer.setSource(AssetSource('sounds/quiz/incorrect_choice.wav'));
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question != oldWidget.question) {
      setState(() => _selectedIndex = null);
    }
  }

  @override
  void dispose() {
    _correctPlayer.dispose();
    _incorrectPlayer.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (_selectedIndex != null) return;
    setState(() => _selectedIndex = index);
    final correct = index == widget.question.correctAnswerIndex;
    (correct ? _correctPlayer : _incorrectPlayer).resume();
    widget.onAnswered?.call(correct);
  }

  Color _colorFor(int index) {
    if (_selectedIndex == null) return _neutralColor;

    final answeredCorrectly = _selectedIndex == widget.question.correctAnswerIndex;
    if (index == _selectedIndex) {
      return answeredCorrectly ? _correctColor : _wrongColor;
    }
    // Se errou, revela qual era a certa; o resto fica desabilitado.
    if (!answeredCorrectly && index == widget.question.correctAnswerIndex) {
      return _correctColor;
    }
    return _disabledColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5).withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.question.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3F5C),
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < widget.question.answers.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _AnswerButton(
                label: widget.question.answers[i],
                color: _colorFor(i),
                disabled: _selectedIndex != null && _colorFor(i) == _disabledColor,
                onTap: () => _selectAnswer(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool disabled;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.color,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: disabled
              ? Border.all(color: Colors.white.withValues(alpha: 0.5))
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: disabled
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
