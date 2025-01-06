import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
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

// States
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

class GameBloc extends Bloc<GameEvent, GameState> {
  late int _targetNumber;
  late int _maxAttempts;
  late List<int> _previousGuesses;

  GameBloc() : super(GameInitial()) {
    on<StartNewGameEvent>(_onStartNewGame);
    on<MakeGuessEvent>(_onMakeGuess);
  }

  void _onStartNewGame(StartNewGameEvent event, Emitter<GameState> emit) {
    _maxAttempts = event.maxAttempts;
    _targetNumber = Random().nextInt(event.maxNumber) + 1;
    _previousGuesses = [];

    emit(GameInProgress(
      remainingAttempts: _maxAttempts,
      maxNumber: event.maxNumber,
      previousGuesses: _previousGuesses,
    ));
  }

  void _onMakeGuess(MakeGuessEvent event, Emitter<GameState> emit) {
    if (state is GameInProgress) {
      _previousGuesses.add(event.guess);

      if (event.guess == _targetNumber) {
        emit(GameWon(
          targetNumber: _targetNumber,
          attemptsUsed: _previousGuesses.length,
        ));
        return;
      }

      final remainingAttempts = _maxAttempts - _previousGuesses.length;

      if (remainingAttempts <= 0) {
        emit(GameLost(targetNumber: _targetNumber));
        return;
      }

      String hint = event.guess < _targetNumber ? 'Больше!' : 'Меньше!';

      emit(GameInProgress(
        remainingAttempts: remainingAttempts,
        maxNumber: (state as GameInProgress).maxNumber,
        previousGuesses: _previousGuesses,
        hint: hint,
      ));
    }
  }
}