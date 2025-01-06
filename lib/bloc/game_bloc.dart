import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'events/game_event.dart';
import 'states/game_state.dart';

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