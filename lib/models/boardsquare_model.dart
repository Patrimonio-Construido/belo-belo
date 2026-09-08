enum BoardSpaceType {
  start,
  end,
  normal,
  bonus,
  penalty,
}

class BoardSpace {
  final BoardSpaceType type;
  final double xPercentage;
  final double yPercentage;

  BoardSpace({
    required this.type,
    required this.xPercentage,
    required this.yPercentage,
  });
}