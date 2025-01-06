import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/game_screen.dart';
import 'bloc/game_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Угадай число',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: const GameScreen(),
      ),
    );
  }
}