import 'package:belobelo/data/boardsquare_data.dart';
import 'package:belobelo/widgets/boardsquare_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:belobelo/data/player_data.dart';
import 'package:belobelo/widgets/dice_widget.dart';
import 'package:belobelo/widgets/player_widget.dart';

void main() {
  // Forçar a orientação de tela horizontal
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belo Belo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DiceWidget(
              onRollEnd: (value) { /// callback que retorna o valor do dado
                debugPrint('rolled $value');
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final player in players)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: PlayerWidget(player: player),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final boardSquare in boardSquares)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: BoardSquareWidget(boardSquare: boardSquare)
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
