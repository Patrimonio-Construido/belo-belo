import 'package:belobelo/models/boardsquare_model.dart';

final List<BoardSpace> boardSpaces = [
  BoardSpace(type: BoardSpaceType.start, xPercentage: 0.0, yPercentage: 0.0),
  BoardSpace(type: BoardSpaceType.normal, xPercentage: 0.2, yPercentage: 0.2),
  BoardSpace(type: BoardSpaceType.bonus, xPercentage: 0.4, yPercentage: 0.4),
  BoardSpace(type: BoardSpaceType.penalty, xPercentage: 0.6, yPercentage: 0.6),
  BoardSpace(type: BoardSpaceType.end, xPercentage: 1.0, yPercentage: 1.0),
];