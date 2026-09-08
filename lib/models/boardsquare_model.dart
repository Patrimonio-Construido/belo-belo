enum BoardSquareType {
  start,
  end,
  normal,
  bonus,
  penalty,
}

class BoardSquare {
  final BoardSquareType type;
  final double xPercentage;
  final double yPercentage;

  BoardSquare({
    required this.type,
    required this.xPercentage,
    required this.yPercentage,
  });
}