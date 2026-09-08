import 'package:belobelo/models/boardsquare_model.dart';

final List<BoardSquare> boardSquares = [
  BoardSquare(type: BoardSquareType.start, xPercentage: 0.0, yPercentage: 0.0),
  BoardSquare(type: BoardSquareType.normal, xPercentage: 0.2, yPercentage: 0.2),
  BoardSquare(type: BoardSquareType.bonus, xPercentage: 0.4, yPercentage: 0.4),
  BoardSquare(type: BoardSquareType.penalty, xPercentage: 0.6, yPercentage: 0.6),
  BoardSquare(type: BoardSquareType.end, xPercentage: 1.0, yPercentage: 1.0),
];
