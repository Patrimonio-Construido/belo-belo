import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v_math;

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

class DiceWidget3D extends StatefulWidget {
  final double size;
  final ValueChanged<int>? onRollEnd;

  const DiceWidget3D({super.key, this.size = 100, this.onRollEnd});

  @override
  State<DiceWidget3D> createState() => _DiceWidget3DState();
}

class _DiceWidget3DState extends State<DiceWidget3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  final _random = Random();

  // Face rotation required so each number sits on TOP (facing +Y)
  static const Map<int, List<double>> _targetAngles = {
    1: [-pi / 2, 0.0, 0.0],
    2: [0.0, 0.0, 0.0],
    3: [0.0, 0.0, -pi / 2],
    4: [0.0, 0.0, pi / 2],
    5: [pi, 0.0, 0.0],
    6: [pi / 2, 0.0, 0.0],
  };

  int _rolledValue = 1;
  bool _isRolling = false;

  double _startX = -pi / 2, _startY = 0.0, _startZ = 0.0;
  double _targetX = -pi / 2, _targetY = 0.0, _targetZ = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1250),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.addStatusListener(_onStatusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _isRolling = false;
        _startX = _targetX % (2 * pi);
        _startY = _targetY % (2 * pi);
        _startZ = _targetZ % (2 * pi);
      });
      widget.onRollEnd?.call(_rolledValue);
    }
  }

  void _rollDice() {
    if (_isRolling) return;

    final nextValue = _random.nextInt(6) + 1;
    final baseTarget = _targetAngles[nextValue]!;

    final spinsX = (_random.nextInt(2) + 2) * 2 * pi;
    final spinsY = (_random.nextInt(2) + 2) * 2 * pi;
    final spinsZ = (_random.nextInt(2) + 1) * 2 * pi;

    setState(() {
      _isRolling = true;
      _rolledValue = nextValue;
      _targetX = _startX + spinsX + baseTarget[0];
      _targetY = _startY + spinsY + baseTarget[1];
      _targetZ = _startZ + spinsZ + baseTarget[2];
    });

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRolling ? null : _rollDice,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final t = _animation.value;

          // Interpolate cube tumbling angles
          final currentX = _startX + (_targetX - _startX) * t;
          final currentY = _startY + (_targetY - _startY) * t;
          final currentZ = _startZ + (_targetZ - _startZ) * t;

          // Camera blends from full 3D tilt during roll to completely flat (0, 0) at rest
          final rollFactor = _isRolling ? (1.0 - t) : 0.0;
          final cameraPitch = -0.96 * rollFactor; // Flattens to 0.0 (top-down view)
          final cameraYaw = (-pi / 4) * rollFactor; // Squares up parallel to the screen

          return SizedBox(
            width: widget.size * 1.5,
            height: widget.size * 1.5,
            child: Center(
              child: _Cube3D(
                size: widget.size,
                rotX: currentX,
                rotY: currentY,
                rotZ: currentZ,
                cameraPitch: cameraPitch,
                cameraYaw: cameraYaw,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Cube3D extends StatelessWidget {
  final double size;
  final double rotX;
  final double rotY;
  final double rotZ;
  final double cameraPitch;
  final double cameraYaw;

  const _Cube3D({
    required this.size,
    required this.rotX,
    required this.rotY,
    required this.rotZ,
    required this.cameraPitch,
    required this.cameraYaw,
  });

  @override
  Widget build(BuildContext context) {
    final half = (size + 0.5) / 2;

    final faces = [
      _FaceTransform(1, Matrix4.identity()..translate(0.0, 0.0, half)),
      _FaceTransform(6, Matrix4.identity()..rotateY(pi)..translate(0.0, 0.0, half)),
      _FaceTransform(2, Matrix4.identity()..rotateX(-pi / 2)..translate(0.0, 0.0, half)),
      _FaceTransform(5, Matrix4.identity()..rotateX(pi / 2)..translate(0.0, 0.0, half)),
      _FaceTransform(3, Matrix4.identity()..rotateY(pi / 2)..translate(0.0, 0.0, half)),
      _FaceTransform(4, Matrix4.identity()..rotateY(-pi / 2)..translate(0.0, 0.0, half)),
    ];

    // Transition from isometric 3D into an overhead top-down view
    final cameraMatrix = Matrix4.identity()
      ..setEntry(3, 2, 0.0003)
      ..rotateX(cameraPitch)
      ..rotateY(cameraYaw);

    final diceMatrix = Matrix4.identity()
      ..rotateX(rotX)
      ..rotateY(rotY)
      ..rotateZ(rotZ);

    final totalMatrix = cameraMatrix * diceMatrix;

    final cameraDirection = v_math.Vector3(0, 0, 1);

    // Luz frontal direta (vindo da tela/câmera na direção da face visível)
    // O leve desvio (-0.15 no Y) preserva um brilho sutil na borda superior
    final frontLight = v_math.Vector3(0.0, -0.15, 1.0)..normalize();

    final visibleFaces = <_RenderFace>[];

    for (final face in faces) {
      final faceTransform = totalMatrix * face.transform;
      final normal = (faceTransform.getRotation() * v_math.Vector3(0, 0, 1))..normalize();

      // Back-face culling
      if (normal.dot(cameraDirection) > 0.001) {
        // Dot product contra a luz frontal:
        // A face frontal fica em 1.0 (brilho máximo) e as laterais caem para ~0.60 (sombra natural)
        final lightIntensity = normal.dot(frontLight).clamp(0.0, 1.0);
        final shade = 0.60 + (0.40 * lightIntensity);
        final depth = faceTransform.transform3(v_math.Vector3.zero()).z;

        visibleFaces.add(_RenderFace(
          faceIndex: face.faceIndex,
          transform: faceTransform,
          shadeFactor: shade,
          depth: depth,
        ));
      }
    }

    // Painter's algorithm sort
    visibleFaces.sort((a, b) => a.depth.compareTo(b.depth));

    const baseColor = Color(0xFFF9F6EE);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Solid backing gap fillers during the 3D phase
        for (final item in visibleFaces)
          Transform(
            alignment: Alignment.center,
            transform: item.transform,
            child: Container(
              width: size,
              height: size,
              color: Color.fromRGBO(
                (baseColor.r * 255 * (item.shadeFactor * 0.88)).toInt(),
                (baseColor.g * 255 * (item.shadeFactor * 0.88)).toInt(),
                (baseColor.b * 255 * (item.shadeFactor * 0.88)).toInt(),
                1.0,
              ),
            ),
          ),

        // Rounded face caps
        for (final item in visibleFaces)
          Transform(
            alignment: Alignment.center,
            transform: item.transform,
            child: _DiceFace(
              value: item.faceIndex,
              size: size,
              shadeFactor: item.shadeFactor,
            ),
          ),
      ],
    );
  }
}

class _FaceTransform {
  final int faceIndex;
  final Matrix4 transform;
  _FaceTransform(this.faceIndex, this.transform);
}

class _RenderFace {
  final int faceIndex;
  final Matrix4 transform;
  final double shadeFactor;
  final double depth;

  _RenderFace({
    required this.faceIndex,
    required this.transform,
    required this.shadeFactor,
    required this.depth,
  });
}

class _DiceFace extends StatelessWidget {
  final int value;
  final double size;
  final double shadeFactor;

  const _DiceFace({
    required this.value,
    required this.size,
    required this.shadeFactor,
  });

  @override
  Widget build(BuildContext context) {
    final pipSize = size * 0.17;
    const baseColor = Color(0xFFF9F6EE);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color.fromRGBO(
          (baseColor.r * 255 * shadeFactor).toInt(),
          (baseColor.g * 255 * shadeFactor).toInt(),
          (baseColor.b * 255 * shadeFactor).toInt(),
          1.0,
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.12),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.16),
        child: Stack(
          children: [
            for (final alignment in _pipLayouts[value]!)
              Align(
                alignment: alignment,
                child: Container(
                  width: pipSize,
                  height: pipSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B1B),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.25 * shadeFactor),
                        offset: const Offset(-0.8, -0.8),
                        blurRadius: 0.5,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}