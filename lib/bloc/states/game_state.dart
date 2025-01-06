abstract class GameState {}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final int remainingAttempts;
  final int maxNumber;
  final List<int> previousGuesses;
  final String? hint;

  GameInProgress({
    required this.remainingAttempts,
    required this.maxNumber,
    required this.previousGuesses,
    this.hint,
  });
}

class GameWon extends GameState {
  final int targetNumber;
  final int attemptsUsed;

  GameWon({required this.targetNumber, required this.attemptsUsed});
}

class GameLost extends GameState {
  final int targetNumber;

  GameLost({required this.targetNumber});
}