// lib/screens/timer_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/workout_config.dart';

enum WorkoutPhase { preparation, exercise, rest, restBetweenRounds, finished }

class TimerExecution extends StatefulWidget {
  final WorkoutConfig config;

  const TimerExecution({super.key, required this.config});

  @override
  State<TimerExecution> createState() => _TimerExecutionState();
}

class _TimerExecutionState extends State<TimerExecution> {
  late int _secondsRemaining;
  late WorkoutPhase _currentPhase;
  int _currentCycle = 1;
  int _currentRound = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPreparation();
  }

  void _startPreparation() {
    _currentPhase = WorkoutPhase.preparation;
    _secondsRemaining = widget.config.preparationTime;
    _startTimer();
  }

  void _startExercise() {
    _currentPhase = WorkoutPhase.exercise;
    _secondsRemaining = widget.config.exerciseTime;
    _startTimer();
  }

  void _startRest() {
    _currentPhase = WorkoutPhase.rest;
    _secondsRemaining = widget.config.restBetweenExercises;
    _startTimer();
  }

  void _startRestBetweenRounds() {
    _currentPhase = WorkoutPhase.restBetweenRounds;
    _secondsRemaining = widget.config.restBetweenRounds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _nextPhase();
        }
      });
    });
  }

  void _nextPhase() {
    switch (_currentPhase) {
      case WorkoutPhase.preparation:
        _startExercise();
        break;
      case WorkoutPhase.exercise:
        if (_currentCycle < widget.config.cycles) {
          _currentCycle++;
          _startRest();
        } else if (_currentRound < widget.config.rounds) {
          _currentRound++;
          _currentCycle = 1;
          _startRestBetweenRounds();
        } else {
          _finishWorkout();
        }
        break;
      case WorkoutPhase.rest:
        _startExercise();
        break;
      case WorkoutPhase.restBetweenRounds:
        _startExercise();
        break;
      case WorkoutPhase.finished:
        break;
    }
  }

  void _finishWorkout() {
    _currentPhase = WorkoutPhase.finished;
    _secondsRemaining = 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¡Entrenamiento completado!'),
        content: const Text('¡Has terminado todas las rondas!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Color _backgroundColor() {
    switch (_currentPhase) {
      case WorkoutPhase.preparation:
        return const Color(0xFF1E3A8A); // Azul oscuro
      case WorkoutPhase.exercise:
        return const Color(0xFF166534); // Verde oscuro
      case WorkoutPhase.rest:
        return const Color(0xFF1E40AF); // Azul grisáceo
      case WorkoutPhase.restBetweenRounds:
        return const Color(0xFF5B21B6); // Morado oscuro
      case WorkoutPhase.finished:
        return Colors.grey;
    }
  }

  String _phaseLabel() {
    switch (_currentPhase) {
      case WorkoutPhase.preparation:
        return 'Preparación';
      case WorkoutPhase.exercise:
        return 'Ejercicio';
      case WorkoutPhase.rest:
        return 'Descanso';
      case WorkoutPhase.restBetweenRounds:
        return 'Descanso entre rondas';
      case WorkoutPhase.finished:
        return '¡Terminado!';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _phaseLabel(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '$_secondsRemaining s',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Ronda: $_currentRound / ${widget.config.rounds}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                'Ciclo: $_currentCycle / ${widget.config.cycles}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
                child: const Text('Cancelar entrenamiento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
