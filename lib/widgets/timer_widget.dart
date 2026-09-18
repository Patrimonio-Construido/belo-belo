import 'dart:ui';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;
  final double size;
  final VoidCallback? onTimeUp;

  const TimerWidget({
    super.key,
    this.duration = const Duration(seconds: 15),
    this.size = 72,
    this.onTimeUp,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  static const _startColor = Colors.white;
  static const _midColor = Color(0xFFC9A961); // warm gold
  static const _endColor = Color(0xFFC97B5A); // muted terracotta

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _controller.addStatusListener(_onStatusChanged);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onTimeUp?.call();
    }
  }

  /// Reinicia a contagem ao tocar no widget.
  /// só para testes, não deve estar em produção.
  void _debugResetOnTap() {
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final remainingFraction = 1 - _controller.value;
        final remainingSeconds =
            (widget.duration.inMilliseconds * remainingFraction / 1000)
                .ceil();
        final sliceColor = _controller.value <= 0.5
            ? Color.lerp(_startColor, _midColor, _controller.value / 0.5)!
            : Color.lerp(
                _midColor,
                _endColor,
                (_controller.value - 0.5) / 0.5,
              )!;

        return GestureDetector(
          onTap: kDebugMode ? _debugResetOnTap : null,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.4),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.7),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.expand(
                  child: CustomPaint(
                    painter: _TimerSlicePainter(
                      remainingFraction: remainingFraction,
                      color: sliceColor,
                    ),
                  ),
                ),
                Text(
                  '$remainingSeconds',
                  style: TextStyle(
                    fontSize: widget.size * 0.28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3F5C),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimerSlicePainter extends CustomPainter {
  final double remainingFraction;
  final Color color;

  _TimerSlicePainter({required this.remainingFraction, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const startAngle = -3.14159265 / 2; // 12 o'clock
    final sweepAngle = 2 * 3.14159265 * remainingFraction;

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TimerSlicePainter oldDelegate) {
    return oldDelegate.remainingFraction != remainingFraction ||
        oldDelegate.color != color;
  }
}
