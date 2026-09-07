import 'dart:math';

import 'package:flutter/material.dart';

const Map<int, List<Alignment>> _pipLayouts = {
  1: [Alignment.center],
  2: [Alignment.topLeft, Alignment.bottomRight],
  3: [Alignment.topLeft, Alignment.center, Alignment.bottomRight],
  4: [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ],
  5: [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.center,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ],
  6: [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ],
};

class DiceWidget extends StatefulWidget {
  final double size;
  final ValueChanged<int>? onRollEnd;

  const DiceWidget({super.key, this.size = 72, this.onRollEnd});

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget>
    with SingleTickerProviderStateMixin {
  static const _cycleSteps = 12;
  static const _settleThreshold = 0.85;

  late final AnimationController _controller;
  final _random = Random();

  int _displayedValue = 1;
  int _lastRolledValue = 1;
  bool _isRolling = false;
  int _lastStep = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTick() {
    final value = _controller.value;
    if (value >= _settleThreshold) {
      if (_displayedValue != _lastRolledValue) {
        setState(() => _displayedValue = _lastRolledValue);
      }
      return;
    }

    final step = (value * _cycleSteps).floor();
    if (step != _lastStep) {
      _lastStep = step;
      setState(() => _displayedValue = _randomFaceExcluding(_displayedValue));
    }
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() => _isRolling = false);
      widget.onRollEnd?.call(_lastRolledValue);
    }
  }

  int _randomFaceExcluding(int exclude) {
    var value = _random.nextInt(6) + 1;
    while (value == exclude) {
      value = _random.nextInt(6) + 1;
    }
    return value;
  }

  void _rollDice() {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
      _lastRolledValue = _random.nextInt(6) + 1;
      _lastStep = -1;
    });
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRolling ? null : _rollDice,
      child: _DiceFace(value: _displayedValue, size: widget.size),
    );
  }
}

class _DiceFace extends StatelessWidget {
  final int value;
  final double size;

  const _DiceFace({required this.value, required this.size});

  @override
  Widget build(BuildContext context) {
    final pipSize = size * 0.14;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF5),
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(color: Colors.black12, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.18),
        child: Stack(
          children: [
            for (final alignment in _pipLayouts[value]!)
              Align(
                alignment: alignment,
                child: Container(
                  width: pipSize,
                  height: pipSize,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
