import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/events/game_event.dart';
import '../bloc/game_bloc.dart';
import '../bloc/states/game_state.dart';
import 'settings_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _guessController = TextEditingController();
  late GameSettings gameSettings;

  @override
  void initState() {
    super.initState();
    gameSettings = GameSettings(maxNumber: 100, maxAttempts: 10);
    _startNewGame();
  }

  void _startNewGame() {
    context.read<GameBloc>().add(StartNewGameEvent(
      maxNumber: gameSettings.maxNumber,
      maxAttempts: gameSettings.maxAttempts,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Угадай число'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final newSettings = await Navigator.push<GameSettings>(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    initialSettings: gameSettings,
                  ),
                ),
              );

              if (newSettings != null) {
                setState(() {
                  gameSettings = newSettings;
                });
                _startNewGame();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameInProgress) {
            return _buildGameInProgress(state);
          } else if (state is GameWon) {
            return _buildGameWon(state);
          } else if (state is GameLost) {
            return _buildGameLost(state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildGameInProgress(GameInProgress state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Я загадал число между 1 и ${state.maxNumber}',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Попыток: ${state.remainingAttempts}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (state.hint != null) ...[
            const SizedBox(height: 10),
            Text(
              state.hint!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: _guessController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Введи число',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final guess = int.tryParse(_guessController.text);
              if (guess != null) {
                context.read<GameBloc>().add(MakeGuessEvent(guess: guess));
                _guessController.clear();
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameWon(GameWon state) {
    return _buildGameEndScreen(
      'Поздравляю!',
      'Ты угадал(а) за ${state.attemptsUsed} попыток!\nЯ загадывал число ${state.targetNumber}',
      Colors.green,
    );
  }

  Widget _buildGameLost(GameLost state) {
    return _buildGameEndScreen(
      'Game Over',
      'Попытки закончились.\nА загадывал я число ${state.targetNumber}',
      Colors.red,
    );
  }

  Widget _buildGameEndScreen(String title, String message, Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _startNewGame,
              child: const Text('Играть заново'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }
}