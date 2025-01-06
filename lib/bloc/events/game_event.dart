abstract class GameEvent {}

class StartNewGameEvent extends GameEvent {
  final int maxNumber;
  final int maxAttempts;

  StartNewGameEvent({required this.maxNumber, required this.maxAttempts});
}

class MakeGuessEvent extends GameEvent {
  final int guess;

  MakeGuessEvent({required this.guess});
}