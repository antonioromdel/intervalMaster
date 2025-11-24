// lib/screens/timer_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intervalmaster/models/sounds.dart';
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
  late int _totalPhaseSeconds;
  late WorkoutPhase _currentPhase;

  int _currentCycle = 1;
  int _currentRound = 1;
  Timer? _timer;

  final Sounds _player = Sounds();

  @override
  void initState() {
    super.initState();
    _startPreparation();
  }

  // ---- FASES ----
  void _startPreparation() {
    _currentPhase = WorkoutPhase.preparation;
    _totalPhaseSeconds = widget.config.preparationTime;
    _secondsRemaining = _totalPhaseSeconds;
    _startTimer();
  }

  void _startExercise() {
    _currentPhase = WorkoutPhase.exercise;
    _totalPhaseSeconds = widget.config.exerciseTime;
    _secondsRemaining = _totalPhaseSeconds;
    _player.playStart();
    _startTimer();
  }

  void _startRest() {
    _currentPhase = WorkoutPhase.rest;
    _totalPhaseSeconds = widget.config.restBetweenExercises;
    _secondsRemaining = _totalPhaseSeconds;
    _startTimer();
  }

  void _startRestBetweenRounds() {
    _currentPhase = WorkoutPhase.restBetweenRounds;
    _totalPhaseSeconds = widget.config.restBetweenRounds;
    _secondsRemaining = _totalPhaseSeconds;
    _startTimer();
  }

  // ---- CONTADOR ----
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Sonido de cuenta atrás
        if (_secondsRemaining <= 3 && _secondsRemaining > 0) {
          _player.playCount();
        }

        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _nextPhase();
        }
      });
    });
  }

  // ---- CAMBIO DE FASE ----
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

  // ---- FINALIZAR ----
  void _finishWorkout() async {
    _currentPhase = WorkoutPhase.finished;
    _secondsRemaining = 0;

    await _player.playFinish();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¡Entrenamiento completado!'),
        content: const Text('¡Enhorabuena! ¡Has terminado todas las rondas!'),
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

  // ---- COLORES ----
  Color _backgroundColor() {
    switch (_currentPhase) {
      case WorkoutPhase.preparation:
        return const Color(0xFF1E3A8A);
      case WorkoutPhase.exercise:
        return const Color(0xFF166534);
      case WorkoutPhase.rest:
        return const Color(0xFF1E40AF);
      case WorkoutPhase.restBetweenRounds:
        return const Color(0xFF5B21B6);
      case WorkoutPhase.finished:
        return Colors.grey;
    }
  }

  String _phaseLabel() {
    switch (_currentPhase) {
      case WorkoutPhase.preparation:
        return '¡Prepárate!';
      case WorkoutPhase.exercise:
        return '¡Vamos! ¡Dale caña!';
      case WorkoutPhase.rest:
        return 'Recupera un poco...';
      case WorkoutPhase.restBetweenRounds:
        return 'Un descanso... Y seguimos';
      case WorkoutPhase.finished:
        return '¡Hemos terminado!';
    }
  }

  double _progressValue() {
    if (_totalPhaseSeconds == 0) return 1;
    return 1 - (_secondsRemaining / _totalPhaseSeconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.disposeSounds();
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

              // ---- BARRA CIRCULAR ----
              SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _progressValue(),
                      strokeWidth: 70,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Text(
                      '$_secondsRemaining s',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

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
