import 'package:belobelo/data/boardsquare_data.dart';
import 'package:belobelo/widgets/boardsquare_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:belobelo/data/player_data.dart';
import 'package:belobelo/data/question_data.dart';
import 'package:belobelo/models/question_model.dart';
import 'package:belobelo/screens/credits_screen.dart';
import 'package:belobelo/screens/quiz_screen.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Belo Belo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

/// Tela de demonstração 1/3: dado.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo 1/3 — Dado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stars),
            tooltip: 'Créditos',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreditsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Próxima demo',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PlayersDemoPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DiceWidget3D(
              size: 72,
              onRollEnd: (value) { /// callback que retorna o valor do dado
                debugPrint('rolled $value');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Tela de demonstração 2/3: jogadores e casas do tabuleiro.
class PlayersDemoPage extends StatelessWidget {
  const PlayersDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo 2/3 — Jogadores e Tabuleiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Próxima demo',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QuizDemoPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

/// Tela de demonstração 3/3: timer e pergunta/resposta do quiz.
class QuizDemoPage extends StatefulWidget {
  const QuizDemoPage({super.key});

  @override
  State<QuizDemoPage> createState() => _QuizDemoPageState();
}

class _QuizDemoPageState extends State<QuizDemoPage> {
  late final Question _question;

  @override
  void initState() {
    super.initState();
    _question = getRandomQuestionAndPop();
  }

  @override
  Widget build(BuildContext context) {
    return QuizScreen(
      backgroundImagePath: 'assets/images/tabuleiro/tabuleiro.jpeg',
      placeName: 'Praça da Liberdade',
      question: _question,
      player: players.first,
      onAnswered: (correct) { /// callback que retorna se acertou
        debugPrint('answered correctly: $correct');
      },
      onTimeUp: () { /// callback que é chamado quando o tempo acaba
        debugPrint('time is up');
      },
    );
  }
}
